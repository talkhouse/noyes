#include "stdlib.h"

// Matrix handling routines.
typedef struct {
  double **data;
  int rows;
  int cols;
} NData2;

NData2 *new_ndata2(int rows, int cols);
void free_ndata2(NData2 *);

// Segmenter
typedef struct {
  double * buf;
  size_t buflen;
  int winsz;
  int winshift;
} Segmenter;

Segmenter * new_segmenter(int winsz, int winshift);
void free_segmenter(Segmenter *s);
NData2 * segmenter_apply(Segmenter* self, double * data, int datalen);

// Hamming Window
typedef struct {
  double * buf;
  size_t buflen;
} HammingWindow;

HammingWindow * new_hamming_window(int window_size);
void free_hamming_window(HammingWindow *s);
NData2 * hamming_window_apply(HammingWindow* self, NData2 *data);

void Init_preemphasis();
void Init_segmenter();
void Init_hamming_window();

