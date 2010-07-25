package talkhouse;

public class Segmenter {
  private double[] buf=null;
  int winsz;
  int winshift;
  static final int MIN_SEGMENTS = 3;

  public Segmenter(int winsz, int winshift) {
    this.winsz = winsz;
    this.winshift = winshift;
  }

  public double[][] apply(double[] data) {
    double[] combo;
    if (buf != null) {
        combo = new double[buf.length + data.length];
        System.arraycopy(buf, 0, combo, 0, buf.length);
        System.arraycopy(data, 0, combo, buf.length, data.length); 
    } else {
        combo = data;
    }
    if (combo.length < winsz + winshift * MIN_SEGMENTS){
        buf = combo;
        return null;
    } else {
        buf = null;
    }
    double[][] result = new double[(combo.length-winsz)/winshift+1][];
    int i = 0;
    int j=0;
    while (i+winsz <= combo.length) {
      double[] seg = new double[winsz];
      System.arraycopy(combo, i, seg, 0, winsz);
      result[j++] = seg;
      i+=winshift;
    }
    
    int bufsize = combo.length - i;
    if (bufsize > 0) {
        if (buf == null || buf.length != bufsize) {
          buf = new double[bufsize];
        }
        System.arraycopy(combo, combo.length - bufsize, buf, 0, bufsize);
    } else {
        buf = null;
    }
    return result;
  }
};
