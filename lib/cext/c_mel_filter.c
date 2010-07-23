#include "c_noyes.h"
#include "stdlib.h"
#include "memory.h"
#include "math.h"

Carr * make_filter(double left, double center, double right,
                               double initFreq, double delta);

MelFilter * new_mel_filter(int srate, int nfft, int nfilt, int lowerf, int upperf) {
  MelFilter *mf = malloc(sizeof(MelFilter));
  Cmat *params = make_bank_parameters(srate, nfft, nfilt, lowerf, upperf);
  mf->len = params->rows;
  mf->indices = malloc(params->rows * sizeof(int));
  mf->weights = malloc(params->rows * sizeof(double*));
  mf->weightlens = malloc(params->rows * sizeof(int));
  int i;
  for (i=0; i<params->rows;++i) {
      Carr * temp = make_filter(params->data[i][0], params->data[i][1],
                                    params->data[i][2], params->data[i][3],
                                    params->data[i][4]);
      mf->indices[i] = round(temp->data[0]);
      int weightlen = temp->rows-1;
      mf->weights[i] = malloc(sizeof(double) * weightlen);
      mf->weightlens[i] = weightlen;
      int j;
      for (j=0; j<weightlen; ++j) {
          double foo = temp->data[j+1];
          mf->weights[i][j] = foo;
      }
      carr_free(temp);
  }
  cmat_free(params);
  return mf;
}

Cmat * mel_filter_apply(MelFilter* self, Cmat * power_spectrum) {
    Cmat *melbanks = cmat_new(power_spectrum->rows, self->len);
    int i;
    for (i=0;i<power_spectrum->rows; ++i) {
        double * spectrum = power_spectrum->data[i];
        int j;
        for (j=0;j<self->len; ++j) {
            int initialIndex = self->indices[j];
            int lenw = self->weightlens[j];
            double * w = self->weights[j];
            double output = 0.0;
            int k;
            for (k=0;k<lenw;++k) {
                int index = initialIndex + k; 
                if (index < power_spectrum->cols) {
                    output += spectrum[index] * w[k];
                }
            }
            melbanks->data[i][j] = output;
        } 
    }
    return melbanks;
}

void mel_filter_free(MelFilter* mf) {
  int i;
  for (i=0;i<mf->len;++i) {
    free(mf->weights[i]);
  }
  free(mf->weights);
  free(mf->weightlens);
  free(mf->indices); 
}

double mel(double f) {
    return 2595.0 * log10(1.0 + f/700.0);
}

static double determine_bin(double inFreq,double stepFreq) {
    return stepFreq * round(inFreq / stepFreq);
}

double melinv(double m) {
    return 700.0 * (pow(10, m/2595.0) - 1.0);
}

//static double[] melinv_array(double[] m) {
//    double[] result = new double[m.length];
//    for (int i=0;i<m.length;++i) {
//        result[i] = melinv(m[i]);
//    }
//    return result;
//}

Cmat *make_bank_parameters(double srate, int nfft, int nfilt,
                                      double lowerf, double upperf) { 
  double * leftEdge = alloca(nfilt*sizeof(double));
  double * rightEdge = alloca(nfilt*sizeof(double));
  double * centerFreq = alloca(nfilt*sizeof(double));
  double melmax = mel(upperf);
  double melmin = mel(lowerf);
  double deltaFreqMel = (melmax - melmin) / (nfilt + 1.0);
  double deltaFreq = srate/nfft;
  leftEdge[0] = determine_bin(lowerf, deltaFreq);
  double nextEdgeMel = melmin;
  int i;
  for (i=0;i<nfilt;++i) {
      nextEdgeMel += deltaFreqMel;
      double nextEdge = melinv(nextEdgeMel);
      centerFreq[i] = determine_bin(nextEdge, deltaFreq);
      if (i > 0) { 
          rightEdge[i-1] = centerFreq[i];
      } if (i < nfilt -1) {
          leftEdge[i+1] = centerFreq[i];
      }
  }
  
  nextEdgeMel += deltaFreqMel;
  double nextEdge = melinv(nextEdgeMel);
  rightEdge[nfilt-1] = determine_bin(nextEdge, deltaFreq);
  Cmat *fparams = cmat_new(nfilt, 5);
  for (i=0;i<nfilt;++i) {
      double initialFreqBin = determine_bin(leftEdge[i], deltaFreq);
      if (initialFreqBin < leftEdge[i]) {
          initialFreqBin += deltaFreq;
      }
      fparams->data[i][0] = leftEdge[i];
      fparams->data[i][1] = centerFreq[i];
      fparams->data[i][2] = rightEdge[i];
      fparams->data[i][3] = initialFreqBin;
      fparams->data[i][4] = deltaFreq;
  }
  return fparams;
}

// Returns an array of weights with one additional element at the zero
// location containing the starting index.
Carr * make_filter(double left, double center, double right,
                               double initFreq, double delta) {
    int nElements = round((right - left)/ delta + 1);
    Carr * filter = carr_new(nElements + 1);
    double height=1.0;
    double leftSlope = height / (center - left);
    double rightSlope = height / (center - right);
    int indexFW =1;
    filter->data[0] = round(initFreq/delta);
    double current;
    for (current=initFreq; current<=right; current+= delta) {
        if (current < center) {
            filter->data[indexFW] = leftSlope * (current - left);
        } else {
            filter->data[indexFW] = height + rightSlope * (current - center);
        }
        indexFW += 1;
    }

    return filter;
}

