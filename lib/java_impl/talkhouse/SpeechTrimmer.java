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
  int scs;
  int ecs;

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
            queue = new LinkedList<double[]>(queue.subList(0, trailer-1));
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
    if (eosReached || speechStarted && queue.size() > ecs)
      return queue.remove();
    else
      return null;
  }
  public boolean eos() {
    return eosReached;
  }
}
