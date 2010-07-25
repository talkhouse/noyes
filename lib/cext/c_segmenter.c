#include "c_noyes.h"
#include "memory.h"

Segmenter * new_segmenter(int winsz, int winshift) {
  Segmenter *s = malloc(sizeof(Segmenter));
  s->buf = NULL;
  s->buflen = 0;
  s->winsz = winsz;
  s->winshift = winshift;
  return s;
};

void segmenter_free(Segmenter *s) {
  if (s->buf) {
    free(s->buf);
  }
 
  free(s);
}

#define MIN_SEGMENTS 3

#include "stdio.h"
Cmat * segmenter_apply(Segmenter* self, Carr *data) {
  double * combo;
  int combolen = 0;
  if (self->buf != NULL) {
      combolen = self->buflen + data->rows;
      combo = alloca((combolen) * sizeof(double));
      memcpy(combo, self->buf, self->buflen * sizeof(double));
      memcpy(combo + self->buflen, data->data, data->rows * sizeof(double));
  } else {
      combo = alloca((data->rows) * sizeof(double));
      combolen = data->rows;
      memcpy(combo, data->data, combolen * sizeof(double));
  }
  if (combolen < self->winsz + self->winshift * MIN_SEGMENTS ) {
      self->buf = realloc(self->buf, combolen * sizeof(double));
      memcpy(self->buf, combo, combolen*sizeof(double));
      self->buflen = combolen;
      return NULL;
  } else {
      if (self->buf != NULL) {
        free(self->buf);
        self->buf = NULL;
      }
  }

  Cmat *M = cmat_new((combolen - combolen % self->winshift - self->winsz +
                        self->winshift)/ self->winshift, self->winsz);
  int i = 0;
  for (i=0;i<M->rows;++i) {
    memcpy(M->data[i], combo + i*self->winshift, self->winsz * sizeof(double));
  }
  
  int bufsize = combolen - M->rows * self->winshift;
  if (bufsize > 0) {
      // Copy the tail end of combo into buf.
      self->buf = realloc(self->buf, bufsize * sizeof(double));
      self->buflen = bufsize;
      memcpy(self->buf, combo + (combolen - bufsize), bufsize*sizeof(double));
  } else {
      self->buf = NULL;
      self->buflen = 0;
  }
  return M;
}
