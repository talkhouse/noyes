package talkhouse;

public class MelFilter {
    int[] indices;
    double[][] weights;

    public MelFilter(int srate, int nfft, int nfilt, int lowerf, int upperf) {
        double[][] params = make_bank_parameters(srate, nfft, nfilt, lowerf, upperf);
        indices = new int[params.length];
        weights = new double[params.length][];
        for (int i=0; i<params.length;++i) {
            double[] temp = make_filter(params[i][0], params[i][1], params[i][2],
                                params[i][3], params[i][4]);
            indices[i] = (int)Math.round(temp[0]);
            weights[i] = new double[temp.length-1];     
            for (int j=0; j<weights[i].length; ++j) {
                double foo = temp[j+1];
                weights[i][j] = foo;
            }
        }
    }

    public double[][] apply(double[][] powerSpectrum) {
        double[][] melbanks = new double[powerSpectrum.length][];
        for (int i=0;i<powerSpectrum.length; ++i) {
            double[] spectrum = powerSpectrum[i];
            melbanks[i] = new double[indices.length];
            for (int j=0;j<indices.length; ++j) {
                int initialIndex = indices[j];
                double[] w = weights[j];
                double output = 0.0;
                for (int k=0;k<w.length;++k) {
                    int index = initialIndex + k; 
                    if (index < spectrum.length) {
                        output += spectrum[index] * w[k];
                    }
                }
                melbanks[i][j] = output;
            } 
        }
        return melbanks;
    }

    public static double mel(double f) {
        return 2595.0 * Math.log10(1.0 + f/700.0);
    }

    public static double[] mel(double[] f) {
        double[] result = new double[f.length];
        for (int i=0;i<f.length;++i) {
            result[i] = mel(f[i]); 
        }
        return result;
    }

    public static double melinv(double m) {
        return 700.0 * (Math.pow(10, m/2595.0) - 1.0);
    }
    
    public static double[] melinv(double[] m) {
        double[] result = new double[m.length];
        for (int i=0;i<m.length;++i) {
            result[i] = melinv(m[i]);
        }
        return result;
    }

    private static double determineBin(double inFreq,double stepFreq) {
        return stepFreq * Math.round(inFreq / stepFreq);
    }
    public static double[][] make_bank_parameters(double srate, int nfft, int nfilt,
                                          double lowerf, double upperf) { 
        double[] leftEdge = new double[nfilt];
        double[] rightEdge = new double[nfilt];
        double[] centerFreq = new double[nfilt];
        double melmax = mel(upperf);
        double melmin = mel(lowerf);
        double deltaFreqMel = (melmax - melmin) / (nfilt + 1.0);
        double deltaFreq = srate/nfft;
        leftEdge[0] = determineBin(lowerf, deltaFreq);
        double nextEdgeMel = melmin;
        for (int i=0;i<nfilt;++i) {
            nextEdgeMel += deltaFreqMel;
            double nextEdge = melinv(nextEdgeMel);
            centerFreq[i] = determineBin(nextEdge, deltaFreq);
            if (i > 0) { 
                rightEdge[i-1] = centerFreq[i];
            } if (i < nfilt -1) {
                leftEdge[i+1] = centerFreq[i];
            }
        }
        
        nextEdgeMel += deltaFreqMel;
        double nextEdge = melinv(nextEdgeMel);
        rightEdge[nfilt-1] = determineBin(nextEdge, deltaFreq);
        double[][] fparams = new double[nfilt][];
        for (int i=0;i<nfilt;++i) {
            double initialFreqBin = determineBin(leftEdge[i], deltaFreq);
            if (initialFreqBin < leftEdge[i]) {
                initialFreqBin += deltaFreq;
            }
            fparams[i] = new double[5];
            fparams[i][0] = leftEdge[i];
            fparams[i][1] = centerFreq[i];
            fparams[i][2] = rightEdge[i];
            fparams[i][3] = initialFreqBin;
            fparams[i][4] = deltaFreq;
        }
        return fparams;
    }

    // Returns an array of weights with one additional element at the zero
    // location containing the starting index.
    public static double[] make_filter(double left, double center, double right,
                                   double initFreq, double delta) {
        int nElements = (int)Math.round((right - left)/ delta + 1);
        double[] filter = new double[nElements + 1];
        double height=1.0;
        double leftSlope = height / (center - left);
        double rightSlope = height / (center - right);
        int indexFW =1;
        filter[0] = Math.round(initFreq/delta);
        for (double current=initFreq; current<=right; current+= delta) {
            if (current < center) {
                filter[indexFW] = leftSlope * (current - left);
            } else {
                filter[indexFW] = height + rightSlope * (current - center);
            }
            indexFW += 1;
        }

        return filter;
    }
};
