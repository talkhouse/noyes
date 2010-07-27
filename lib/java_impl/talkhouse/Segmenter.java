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

    int rows = 1 + (combo.length - winsz - (combo.length - winsz) % winshift)
                    /winshift;
    double[][] result = new double[rows][];

    for (int i=0;i<rows;++i) {
      double[] seg = new double[winsz];
      System.arraycopy(combo, i*winshift, seg, 0, winsz);
      result[i] = seg;
    }
    
    int bufsize = combo.length - rows * winshift;
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
