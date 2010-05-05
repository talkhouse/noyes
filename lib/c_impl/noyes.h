#include "stdlib.h"

typedef struct {
  double * buf;
  size_t buflen;
  int winsz;
  int winshift;
} Segmenter;

typedef struct {
  double **data;
  int rows;
  int cols;
} NData2;

NData2 *new_ndata2(int rows, int cols);
void free_ndata2(NData2 *);

Segmenter * new_segmenter(int winsz, int winshift);
void free_segmenter(Segmenter *s);
