package talkhouse;
import java.util.LinkedList;

public class SpeechTrimmer {
  int leader = 5;
  int trailer = 5;
  boolean speechStarted = false;
  BentCentMarker centMarker = new BentCentMarker(); 
  int falseCount=0;
  int trueCount=0;
  LinkedList<double[]> queue = new LinkedList<double[]>();
  boolean eosReached = false;
  int scs = 20;
  int ecs = 50;
  Segmenter seg;

  public SpeechTrimmer(int frequency) {
    seg = new Segmenter(frequency/100, frequency/100);
  }

  public double[][] apply(double[] pcm) {
    if (eos())
      return null;

    double[][] segments = seg.apply(pcm);
    double[][] speechSegments= new double[segments.length][];
    int speechCount=0;
    for (int i=0;i<segments.length;++i) {
      enqueue(segments[i]);
      double[] centispeech = dequeue();
      while (centispeech != null) {
        speechSegments[speechCount++] = centispeech;
        centispeech = dequeue();
      }
      if (eos())
        break;
    }

    if (eos() && speechCount == 0)
      return null;

    double[][] result = new double[speechCount][];
    for (int i=0;i<speechCount;++i) {
      result[i] = speechSegments[i];
    }
    return result;
  }

  public void enqueue(double[] pcm) {
    if (eosReached)
      return;

    queue.offer(pcm);
    if (centMarker.apply(pcm)) {
      falseCount = 0;
      trueCount += 1;
    } else {
      falseCount += 1;
      trueCount = 0;
    }
    if (speechStarted) {
        if (falseCount == ecs) {
            eosReached = true;
            int newSize = queue.size() - ecs + trailer;
            queue = new LinkedList<double[]>(queue.subList(0, newSize));
        }
    } else if (trueCount > scs) {
      if (leader + scs < queue.size()) {
        int start = queue.size() - leader - scs - 1;
        int remainder = queue.size() - start;
        queue = new LinkedList<double[]>(queue.subList(
                                          start, start + remainder));
      }
      speechStarted = true;
    }
  }

  public double[] dequeue() {
    if (eosReached  && queue.size() > 0 || speechStarted && queue.size() > ecs) {
      return queue.remove();
    } else
      return null;
  }
  public boolean eos() {
    return eosReached;
  }
}
