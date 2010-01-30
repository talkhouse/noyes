package talkhouse;

public class Preemphasizer { 
    double factor;
    double prior;
 
    public Preemphasizer(double factor) {
      this.factor = factor;
      this.prior = 0;
    }
    public double[] apply(double[] data) {
        double current_prior = prior;
        prior = data[data.length-1];
        for (int i = 0; i < data.length; ++i) {
            double current = data[i];
            data[i] = current - factor * current_prior;
            current_prior = current;
        }
        return data;
    }
};
