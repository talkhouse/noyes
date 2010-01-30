package talkhouse;

public class DoubleDeltaFilter {
    double[][] previous;

    public DoubleDeltaFilter() {
      previous = null;
    }
    
    public double[][][] apply(double[][] data) {
        if (previous == null) {
            previous = new double[3][];
            for (int i=0; i<previous.length; ++i) {
                previous[i] = new double[data[0].length];
                for (int j=0;j<data[0].length;++j) {
                    previous[i][j] = data[0][j];
                }
            }
        }
        double[][] buf = new double[data.length + previous.length][];
        for (int i=0;i<previous.length;++i) {
          buf[i] = previous[i];
        }
        for (int i=0;i<data.length;++i) {
          buf[i+previous.length] = data[i];
        }
        double[][][] dd = new double[buf.length - 6][][];
        //for (int i=3; i < buf.length - buf.length-3; ++i) {
        for (int k=0;k<dd.length;++k) {
            int i = k + 3;
            dd[k] = new double[3][];
            double[] delta = new double[buf[i].length]; 
            for (int j=0; j<delta.length; ++j) {
                delta[j] = buf[i+2][j] - buf[i-2][j];
            }
            double[] double_delta = new double[buf[i].length]; 
            for (int j=0; j<double_delta.length; ++j) {
                double_delta[j] = buf[i+3][j] - buf[i-1][j] - buf[i+1][j] +
                                                              buf[i-3][j];
            }
            dd[k][0] = buf[i];
            dd[k][1] = delta;
            dd[k][2] = double_delta;
        }
        previous = new double[Math.min(6, buf.length)][];
        for (int i=0;i<previous.length;++i) {
          previous[i] = buf[buf.length - previous.length + i];
        }

        return dd;
    }
    public double[][][] finalEstimate() {
        double[][] cepstra = new double[3][];
        for (int i=0;i<3;++i) {
            cepstra[i] = new double[previous[0].length];
            for (int j=0;j<previous[0].length;++j) {
                cepstra[i][j] = previous[previous.length-1][j];
            }
        }
        return apply(cepstra);
    }
};
