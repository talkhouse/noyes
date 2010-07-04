#include "noyes.h"
#include "stdlib.h"
#include "memory.h"
#include "math.h"
#include "stdio.h"

NMat * dft(double * data, int datalen, int size) {
    if (datalen> size) {
        fprintf(stderr,"Size(%d) must be larger than data length(%d)", size, datalen);
        return NULL;
    }
    NMat *M = nmat_new(2, size);
    double * real = M->data[0];
    double * imag = M->data[1];
    int j=0,i;
    for (i=0;i<size;++i) {
      imag[i] = 0.0;
      real[i] = 0.0;
    }
    memcpy(real, data, datalen * sizeof(double));

    for (i=0;i<size;++i) {
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
     int k=1,m;
     while (k < size) {
         int incr = 2*k;
         double mul_r = cos(M_PI/k);
         double mul_i = sin(M_PI/k);
         double w_r = 1;
         double w_i = 0;
         for (i=0;i<k;++i) {
             for (m=i;m<size; m+=incr) {
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

    return M;
}
