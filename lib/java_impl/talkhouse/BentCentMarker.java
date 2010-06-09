package talkhouse;

public class BentCentMarker {
  double adjustment = 0.003;
  double averageNumber = 1.0;
  double background = 100.0;
  double level = 0.0;
  double minSignal = 0.0;
  double threshold = 10.0;
  
  public double logRMS(double[] pcm) {
      double sumOfSquares = 0.0;
      for (int i=0;i<pcm.length;++i) {
          sumOfSquares += pcm[i] * pcm[i]; 
      }
      double rms = Math.sqrt(sumOfSquares/pcm.length);
      rms = Math.max(rms, 1);
      return Math.log(rms) * 20;
  }

  public boolean apply(double[] pcm) {
    boolean isSpeech = false;
    double current = logRMS(pcm);
    if (current >= minSignal) {
      level = ((level * averageNumber) + current) / (averageNumber + 1);
      if (current < background) {
        background = current;
      } else {
        background += (current - background) * adjustment;
      }
      if (level < background) {
        level = background;
      }
      isSpeech = level - background > threshold;
    }
    return isSpeech;
  }
}
