package talkhouse;
import java.lang.Math;

public class DiscreteFourierTransform {
    public static double[][] apply(double[] data, int size) throws Exception {
        if (data.length > size) {
            throw new Exception("Size must be larger than data length");
        }
        double[] real = new double[size];
        double[] imag = new double[size];
        System.arraycopy(data,0, real, 0, data.length);

        int j=0;
        for (int i=0;i<size;++i) {
            if (i < j) {
               double temp = real[j];
               real[j] = real[i];
               real[i] = temp;
               temp = imag[j];
               imag[j] = imag[i];
               imag[i] = temp;
            }
            int m = size/2;
            while (j>=m && m> 1) {
                j -= m;
                m /= 2;
            }   
            j+=m;
         }
         int k=1;
         while (k < size) {
             int incr = 2*k;
             double mul_r = Math.cos(Math.PI/k);
             double mul_i = Math.sin(Math.PI/k);
             double w_r = 1;
             double w_i = 0;
             for (int i=0;i<k;++i) {
                 for (int m=i;m<size; m+=incr) {
                     double tmp_r = w_r * real[m+k] - w_i * imag[m+k];
                     double tmp_i = w_r * imag[m+k] + w_i * real[m+k]; 
                     real[m+k] = real[m] - tmp_r; 
                     imag[m+k] = imag[m] - tmp_i; 
                     real[m] = real[m] + tmp_r;
                     imag[m] = imag[m] + tmp_i;
                 } 
                 double tmp_r = w_r * mul_r - w_i * mul_i;
                 double tmp_i = w_r * mul_i + w_i * mul_r; 
                 w_r = tmp_r;
                 w_i = tmp_i;
             }
             k=incr;
         }

        double[][] result = new double[2][];
        result[0] = real;  result[1] = imag;
        return result;
    }
};
