package talkhouse;
import java.util.List;
import java.util.ArrayList;

public class HammingWindow {
    private double[] hammingWindow;
    public HammingWindow(int windowSize) {
        hammingWindow = new double[windowSize]; 
        double twopi = Math.PI * 2;
        for (int i=0;i<windowSize;++i) {
            hammingWindow[i] = 0.54 - 0.46*Math.cos(twopi*i/(windowSize-1));
        }
    }

    public double[][] apply(double[][] data) {
        double[][] result = new double[data.length][];
        for (int i=0;i<data.length;++i) {
            result[i] = new double[data[i].length];
            for (int j=0;j<hammingWindow.length;++j) {
                result[i][j] = hammingWindow[j] * data[i][j];
            }
        }
        return result;
    }
};
