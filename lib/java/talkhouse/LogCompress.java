package talkhouse;

public class LogCompress {
    public static double[][] apply(double[][] m) {
        double[][] result = new double[m.length][];
        for (int i=0;i<m.length;++i) {
            result[i] = new double[m[i].length];
            for (int j=0;j<m[i].length;++j) {
                result[i][j] = m[i][j] > 0 ? Math.log(m[i][j]) : -100;
            }
        }
        return result;
    }
};
        
