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
} Cmat;

typedef struct {
  double ***data;
  int rows;
  int cols;
  int z;
} Cmat3;

typedef struct {
  double *data;
  int rows;
} Carr;

Cmat *cmat_new(int rows, int cols);
void cmat_free(Cmat *);

Carr *narr_new(int rows);
void narr_free(Carr *);
Carr ** mat2arrs(Cmat *M);
Cmat * arrs2mat(Carr **array, int size);
Carr *cmat_flatten(Cmat *M);

// Preemphasizer
typedef struct {
  double factor;
  double prior;
} Preemphasizer;

Preemphasizer * new_preemphasizer(double factor);
void free_preemphasizer(Preemphasizer *self);
Carr *preemphasizer_apply(Preemphasizer *self, Carr *data);

// Segmenter
typedef struct {
  double * buf;
  size_t buflen;
  int winsz;
  int winshift;
} Segmenter;

Segmenter * new_segmenter(int winsz, int winshift);
void free_segmenter(Segmenter *s);
Cmat * segmenter_apply(Segmenter* self, Carr *data);

// Hamming Window
typedef struct {
  double * buf;
  size_t buflen;
} HammingWindow;

HammingWindow * new_hamming_window(int window_size);
void free_hamming_window(HammingWindow *s);
Cmat * hamming_window_apply(HammingWindow* self, Cmat *data);

// Power spectrum
typedef struct {
   int nfft, n_uniq_fft_points;
} PowerSpectrum;

PowerSpectrum * new_power_spectrum(int nfft);
void free_power_spectrum(PowerSpectrum *);
Cmat *power_spectrum_apply(PowerSpectrum *self, Cmat *data);
Cmat * dft(double * data, int datalen, int size);

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
Cmat *make_bank_parameters(double srate, int nfft, int nfilt,
                                      double lowerf, double upperf); 
Cmat * mel_filter_apply(MelFilter* self, Cmat * power_spectrum);
Carr * make_filter(double left, double center, double right,
                               double initFreq, double delta);
double melinv(double m);
double mel(double m);

// Log Compressor
typedef struct {
  double log_zero;
} LogCompressor;

LogCompressor * new_log_compressor(double log_zero);
void free_log_compressor(LogCompressor *lc);
Cmat * log_compressor_apply(LogCompressor *self, Cmat *data);

// Discrete Cosine Transform
typedef struct {
  int rows;
  int cols;
  double **melcos;
} DiscreteCosineTransform;

DiscreteCosineTransform * new_dct(int order, int ncol);
void free_dct(DiscreteCosineTransform *dct);
Cmat * dct_apply(DiscreteCosineTransform *self, Cmat *data);

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
Cmat *live_cmn_apply(LiveCMN *self, Cmat *data);

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
double bent_cent_marker_log_rms(BentCentMarker *self, Carr *data);
int bent_cent_marker_apply(BentCentMarker *self, Carr *data);

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
void speech_trimmer_enqueue(SpeechTrimmer *self, Carr* pcm);
Carr * speech_trimmer_dequeue(SpeechTrimmer *self);
int speech_trimmer_eos(SpeechTrimmer *self);
Cmat * speech_trimmer_apply(SpeechTrimmer *self, Carr* pcm);

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
Cmat *fast_8k_mfcc_apply(Fast8kMfcc *self, Carr *data);

#ifdef __cplusplus
}
#endif
#endif
