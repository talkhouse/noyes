package talkhouse;

import java.lang.IllegalArgumentException;

public class LiveCMN {
    private double[] sums;
    private double[] means;
    private double init_mean;
    private int frame_count;
    private int window_size;
    private int shift;
    public LiveCMN(int dimensions, double init_mean, int window_size,
                   int shift) {
        this.init_mean = init_mean; 
        this.window_size = window_size;
        this.shift = shift;
        sums = new double[dimensions];
        means = new double[dimensions]; 
        means[0] = init_mean;
        frame_count=0;
    }
    public double[][] apply(double[][] dct) {
        if (dct[0].length != means.length) {
            throw new IllegalArgumentException("Wrong number of dimensions");
        }
        double[][] cmn = new double[dct.length][];
        for (int i=0;i<dct.length;++i) {
            cmn[i] = new double[dct[0].length];
            for (int j=0;j<dct[0].length;++j) {
                sums[j] += dct[i][j];
                cmn[i][j] = dct[i][j] - means[j];
            }
            ++frame_count;
            if (frame_count > shift) {
              update();
            }
        }
        return cmn;
    }
    private void update() {
        double per_frame = 1.0 / frame_count;
        for (int i=0; i< means.length; ++i) {
            means[i] = sums[i] * per_frame;
        }
        
        if (means[0] > 70 || means[0] < 5) {
            reset();
        } else if (frame_count >= shift) {
            for (int i=0; i < sums.length; ++i) {
                sums[i] = sums[i] * per_frame * window_size;
                frame_count = window_size;
            }
        }
    }
    private void reset() {
        for (int i=0; i<sums.length; ++i) {
            sums[i] = 0.0;
        }
        for (int i=0; i<means.length; ++i) {
            means[i] = 0.0;
        }
        means[0] = init_mean;
        frame_count = 0;
    }
}
