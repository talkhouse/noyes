#include "stdlib.h"
#ifndef _NOYES_H_
#define _NOYES_H_

#ifdef __cplusplus
extern "C" {
#endif

// Matrix handling routines.
typedef struct {
  double **data;
  int rows;
  int cols;
} NMat;

typedef struct {
  double ***data;
  int rows;
  int cols;
  int z;
} NMat3;

typedef struct {
  double *data;
  int rows;
} NMat1;

NMat *nmat_new(int rows, int cols);
void nmat_free(NMat *);

NMat1 *nmat_new1(int rows);
void nmat_free1(NMat1 *);
NMat1 ** mat2arr(NMat *M);
NMat * nmatrix1_2_nmatrix(NMat1 **array, int size);
NMat1 *nmatrix_flatten(NMat *M);

// Preemphasizer
typedef struct {
  double factor;
  double prior;
} Preemphasizer;

Preemphasizer * new_preemphasizer(double factor);
void free_preemphasizer(Preemphasizer *self);
NMat1 *preemphasizer_apply(Preemphasizer *self, NMat1 *data);

// Segmenter
typedef struct {
  double * buf;
  size_t buflen;
  int winsz;
  int winshift;
} Segmenter;

Segmenter * new_segmenter(int winsz, int winshift);
void free_segmenter(Segmenter *s);
NMat * segmenter_apply(Segmenter* self, NMat1 *data);

// Hamming Window
typedef struct {
  double * buf;
  size_t buflen;
} HammingWindow;

HammingWindow * new_hamming_window(int window_size);
void free_hamming_window(HammingWindow *s);
NMat * hamming_window_apply(HammingWindow* self, NMat *data);

// Power spectrum
typedef struct {
   int nfft, n_uniq_fft_points;
} PowerSpectrum;

PowerSpectrum * new_power_spectrum(int nfft);
void free_power_spectrum(PowerSpectrum *);
NMat *power_spectrum_apply(PowerSpectrum *self, NMat *data);
NMat * dft(double * data, int datalen, int size);

// Mel Filter
typedef struct {
  int len;
  int * indices;
  double ** weights;
  int *weightlens;
} MelFilter;

MelFilter * new_mel_filter(int srate, int nfft, int nfilt, int lowerf,
                                                            int upperf);
void free_mel_filter(MelFilter* mf);
NMat *make_bank_parameters(double srate, int nfft, int nfilt,
                                      double lowerf, double upperf); 
NMat * mel_filter_apply(MelFilter* self, NMat * power_spectrum);
NMat1 * make_filter(double left, double center, double right,
                               double initFreq, double delta);
double melinv(double m);
double mel(double m);

// Log Compressor
typedef struct {
  double log_zero;
} LogCompressor;

LogCompressor * new_log_compressor(double log_zero);
void free_log_compressor(LogCompressor *lc);
NMat * log_compressor_apply(LogCompressor *self, NMat *data);

// Discrete Cosine Transform
typedef struct {
  int rows;
  int cols;
  double **melcos;
} DiscreteCosineTransform;

DiscreteCosineTransform * new_dct(int order, int ncol);
void free_dct(DiscreteCosineTransform *dct);
NMat * dct_apply(DiscreteCosineTransform *self, NMat *data);

typedef struct {
  double * sums;
  double * means;
  double init_mean;
  int dimensions;
  int frame_count;
  int window_size;
  int shift;
} LiveCMN;

LiveCMN * new_live_cmn(int dimensions, double init_mean, int window_size, int shift);
void free_live_cmn(LiveCMN *lcmn);
NMat *live_cmn_apply(LiveCMN *self, NMat *data);

// Silence removal with BentCentMarker and SpeechTrimmer
typedef struct {
  double adjustment;
  double average_number;
  double background;
  double level;
  double min_signal;
  double threshold;
} BentCentMarker;

BentCentMarker * new_bent_cent_marker();
void free_bent_cent_marker(BentCentMarker *self);
double bent_cent_marker_log_rms(BentCentMarker *self, NMat1 *data);
int bent_cent_marker_apply(BentCentMarker *self, NMat1 *data);

#include "n_array_list.h"

typedef struct {
  int leader;
  int trailer;
  int speech_started;
  int false_count;
  int true_count;
  int scs;
  int ecs;
  BentCentMarker *bcm;
  Segmenter *seg;
  NList *queue;
  int eos_reached;
} SpeechTrimmer;

SpeechTrimmer * new_speech_trimmer();
void free_speech_trimmer(SpeechTrimmer *self);
void speech_trimmer_enqueue(SpeechTrimmer *self, NMat1* pcm);
NMat1 * speech_trimmer_dequeue(SpeechTrimmer *self);
int speech_trimmer_eos(SpeechTrimmer *self);
NMat * speech_trimmer_apply(SpeechTrimmer *self, NMat1* pcm);

// Fast 8k mfcc
// This strings together all the algorithms necessary to make mfcc's from an 8k
// signal so you don't have to.
typedef struct {
  Preemphasizer *pre;
  Segmenter *seg;
  HammingWindow *ham;
  PowerSpectrum *pow;
  MelFilter *mel;
  LogCompressor *log;
  DiscreteCosineTransform *dct;
  LiveCMN *cmn;
} Fast8kMfcc;

Fast8kMfcc* new_fast_8k_mfcc();
void free_fast_8k_mfcc(Fast8kMfcc *self);
NMat *fast_8k_mfcc_apply(Fast8kMfcc *self, NMat1 *data);

#ifdef __cplusplus
}
#endif
#endif
