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
} Nmat;

typedef struct {
  double ***data;
  int rows;
  int cols;
  int z;
} Nmat3;

typedef struct {
  double *data;
  int rows;
} Narr;

Nmat *nmat_new(int rows, int cols);
void nmat_free(Nmat *);

Narr *narr_new(int rows);
void narr_free(Narr *);
Narr ** mat2arrs(Nmat *M);
Nmat * arrs2mat(Narr **array, int size);
Narr *nmat_flatten(Nmat *M);

// Preemphasizer
typedef struct {
  double factor;
  double prior;
} Preemphasizer;

Preemphasizer * new_preemphasizer(double factor);
void free_preemphasizer(Preemphasizer *self);
Narr *preemphasizer_apply(Preemphasizer *self, Narr *data);

// Segmenter
typedef struct {
  double * buf;
  size_t buflen;
  int winsz;
  int winshift;
} Segmenter;

Segmenter * new_segmenter(int winsz, int winshift);
void free_segmenter(Segmenter *s);
Nmat * segmenter_apply(Segmenter* self, Narr *data);

// Hamming Window
typedef struct {
  double * buf;
  size_t buflen;
} HammingWindow;

HammingWindow * new_hamming_window(int window_size);
void free_hamming_window(HammingWindow *s);
Nmat * hamming_window_apply(HammingWindow* self, Nmat *data);

// Power spectrum
typedef struct {
   int nfft, n_uniq_fft_points;
} PowerSpectrum;

PowerSpectrum * new_power_spectrum(int nfft);
void free_power_spectrum(PowerSpectrum *);
Nmat *power_spectrum_apply(PowerSpectrum *self, Nmat *data);
Nmat * dft(double * data, int datalen, int size);

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
Nmat *make_bank_parameters(double srate, int nfft, int nfilt,
                                      double lowerf, double upperf); 
Nmat * mel_filter_apply(MelFilter* self, Nmat * power_spectrum);
Narr * make_filter(double left, double center, double right,
                               double initFreq, double delta);
double melinv(double m);
double mel(double m);

// Log Compressor
typedef struct {
  double log_zero;
} LogCompressor;

LogCompressor * new_log_compressor(double log_zero);
void free_log_compressor(LogCompressor *lc);
Nmat * log_compressor_apply(LogCompressor *self, Nmat *data);

// Discrete Cosine Transform
typedef struct {
  int rows;
  int cols;
  double **melcos;
} DiscreteCosineTransform;

DiscreteCosineTransform * new_dct(int order, int ncol);
void free_dct(DiscreteCosineTransform *dct);
Nmat * dct_apply(DiscreteCosineTransform *self, Nmat *data);

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
Nmat *live_cmn_apply(LiveCMN *self, Nmat *data);

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
double bent_cent_marker_log_rms(BentCentMarker *self, Narr *data);
int bent_cent_marker_apply(BentCentMarker *self, Narr *data);

#include "c_array_list.h"

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

SpeechTrimmer * new_speech_trimmer(int frequency);
void free_speech_trimmer(SpeechTrimmer *self);
void speech_trimmer_enqueue(SpeechTrimmer *self, Narr* pcm);
Narr * speech_trimmer_dequeue(SpeechTrimmer *self);
int speech_trimmer_eos(SpeechTrimmer *self);
Nmat * speech_trimmer_apply(SpeechTrimmer *self, Narr* pcm);

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
Nmat *fast_8k_mfcc_apply(Fast8kMfcc *self, Narr *data);

#ifdef __cplusplus
}
#endif
#endif
