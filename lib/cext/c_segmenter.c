#include "noyes.h"
#include "memory.h"

Segmenter * new_segmenter(int winsz, int winshift) {
  Segmenter *s = malloc(sizeof(Segmenter));
  s->buf = NULL;
  s->buflen = 0;
  s->winsz = winsz;
  s->winshift = winshift;
  return s;
};

void free_segmenter(Segmenter *s) {
  if (s->buf) {
    free(s->buf);
  }
 
  free(s);
}

Cmat * segmenter_apply(Segmenter* self, Narr *data) {
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
  if (combolen < self->winsz + self->winshift * 5) {
      self->buf = realloc(self->buf, combolen * sizeof(double));
      memcpy(self->buf, combo, combolen*sizeof(double));
      self->buflen = combolen;
      return NULL;
  } else {
      self->buf = NULL;
  }
  Cmat *M = cmat_new((combolen - self->winsz)/ self->winshift+1, self->winsz);
  int i = 0;
  int j=0;
  while (i+self->winsz <= combolen) {
    memcpy(M->data[j++], combo + i, self->winsz * sizeof(double));
    i+=self->winshift;
  }
  
  int bufsize = combolen- i;
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
