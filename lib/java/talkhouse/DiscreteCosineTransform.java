package talkhouse;

public class DiscreteCosineTransform {
    public double[][] melcos;
    public DiscreteCosineTransform(int order, int ncol) {
        melcos = new double[order][];
        for (int i=0;i<order;++i) {
            double freq = Math.PI * i / ncol;
            double[] ldct = new double[ncol];
            for (int j=0;j<ncol;++j) {
                ldct[j] = Math.cos(freq * (j + 0.5)) / order;
            }
            melcos[i] = ldct;
        }
    }

    public double[][] melcos() {
      return melcos;
    }

    public double[][] apply(double[][] data) {
        double[][] result = new double[data.length][];
        for (int i=0;i<data.length;++i) {
            result[i] = new double[melcos.length];
            for (int j=0;j<melcos.length;++j) {
                for (int k=0;k<melcos[j].length; ++k) {
                    result[i][j] += data[i][k] * melcos[j][k];
                }
            }
        }
        return result;
    }
};
