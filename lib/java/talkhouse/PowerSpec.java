package talkhouse;

public class PowerSpec {
   int nfft, nUniqFftPoints;
   public PowerSpec(int nfft) {
      this.nfft = nfft;
      this.nUniqFftPoints= nfft/2 + 1;
   }

   public double[][] apply(double[][] data) throws Exception {
       double[][] X = new double[data.length][];
       for (int i=0;i<data.length;++i) {
           double[][] ffts = talkhouse.DiscreteFourierTransform.apply(data[i], nfft);
           X[i] = new double[nUniqFftPoints];
           for (int j=0;j<nUniqFftPoints;++j) {
               X[i][j] = Math.pow(ffts[0][j],2) + Math.pow(ffts[1][j],2);
           }
       } 
       return X;
   }
}; 
