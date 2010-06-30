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
} NMatrix;

typedef struct {
  double ***data;
  int rows;
  int cols;
  int z;
} NMatrix3;

typedef struct {
  double *data;
  int rows;
} NMatrix1;

NMatrix *new_nmatrix(int rows, int cols);
void free_nmatrix(NMatrix *);

NMatrix1 *new_nmatrix1(int rows);
void free_nmatrix1(NMatrix1 *);
NMatrix1 ** nmatrix_2_nmatrix1s(NMatrix *M);
NMatrix * nmatrix1_2_nmatrix(NMatrix1 **array, int size);

// Preemphasizer
typedef struct {
  double factor;
  double prior;
} Preemphasizer;

Preemphasizer * new_preemphasizer(double factor);
void free_preemphasizer(Preemphasizer *self);
NMatrix1 *preemphasizer_apply(Preemphasizer *self, NMatrix1 *data);

// Segmenter
typedef struct {
  double * buf;
  size_t buflen;
  int winsz;
  int winshift;
} Segmenter;

Segmenter * new_segmenter(int winsz, int winshift);
void free_segmenter(Segmenter *s);
NMatrix * segmenter_apply(Segmenter* self, NMatrix1 *data);

// Hamming Window
typedef struct {
  double * buf;
  size_t buflen;
} HammingWindow;

HammingWindow * new_hamming_window(int window_size);
void free_hamming_window(HammingWindow *s);
NMatrix * hamming_window_apply(HammingWindow* self, NMatrix *data);

// Power spectrum
typedef struct {
   int nfft, n_uniq_fft_points;
} PowerSpectrum;

PowerSpectrum * new_power_spectrum(int nfft);
void free_power_spectrum(PowerSpectrum *);
NMatrix *power_spectrum_apply(PowerSpectrum *self, NMatrix *data);
NMatrix * dft(double * data, int datalen, int size);

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
NMatrix *make_bank_parameters(double srate, int nfft, int nfilt,
                                      double lowerf, double upperf); 
NMatrix * mel_filter_apply(MelFilter* self, NMatrix * power_spectrum);
NMatrix1 * make_filter(double left, double center, double right,
                               double initFreq, double delta);
double melinv(double m);
double mel(double m);

// Log Compressor
typedef struct {
  double log_zero;
} LogCompressor;

LogCompressor * new_log_compressor(double log_zero);
void free_log_compressor(LogCompressor *lc);
NMatrix * log_compressor_apply(LogCompressor *self, NMatrix *data);

// Discrete Cosine Transform
typedef struct {
  int rows;
  int cols;
  double **melcos;
} DiscreteCosineTransform;

DiscreteCosineTransform * new_dct(int order, int ncol);
void free_dct(DiscreteCosineTransform *dct);
NMatrix * dct_apply(DiscreteCosineTransform *self, NMatrix *data);

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
NMatrix *live_cmn_apply(LiveCMN *self, NMatrix *data);

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
double bent_cent_marker_log_rms(BentCentMarker *self, NMatrix1 *data);
int bent_cent_marker_apply(BentCentMarker *self, NMatrix1 *data);

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
void speech_trimmer_enqueue(SpeechTrimmer *self, NMatrix1* pcm);
NMatrix1 * speech_trimmer_dequeue(SpeechTrimmer *self);
int speech_trimmer_eos(SpeechTrimmer *self);
NMatrix * speech_trimmer_apply(SpeechTrimmer *self, NMatrix1* pcm);

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
NMatrix *fast_8k_mfcc_apply(Fast8kMfcc *self, NMatrix1 *data);

#ifdef __cplusplus
}
#endif
#endif
