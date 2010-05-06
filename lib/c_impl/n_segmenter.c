#include "ruby.h"
#include "noyes.h"

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

NData2 * segmenter_apply(Segmenter* self, double * data, int datalen) {
  double * combo;
  int combolen = 0;
  if (self->buf != NULL) {
      combolen = self->buflen + datalen;
      combo = alloca((combolen) * sizeof(double));
      memcpy(combo, self->buf, self->buflen * sizeof(double));
      memcpy(combo + self->buflen, data, datalen * sizeof(double));
  } else {
      combolen = datalen;
      combo = data;
  }
  if (combolen < self->winsz + self->winshift * 5) {
      self->buf = realloc(self->buf, combolen);
      memcpy(self->buf, combo, combolen);
      self->buflen = combolen;
      return NULL;
  } else {
      self->buf = NULL;
  }
  NData2 *d = new_ndata2((combolen - self->winsz)/ self->winshift+1, self->winsz);
  int i = 0;
  int j=0;
  while (i+self->winsz <= combolen) {
    fprintf(stderr, "j = %d  %f\n", j, combo[1]);
    memcpy(d->data[j++], combo, self->winsz);
    i+=self->winshift;
  }
  
  int bufsize = combolen- i;
  if (bufsize > 0) {
      // Copy the tail end of combo into buf.
      self->buf = realloc(self->buf, bufsize * sizeof(double));
      self->buflen = bufsize;
      memcpy(self->buf, combo + (combolen - bufsize), bufsize);
  } else {
      self->buf = NULL;
      self->buflen = 0;
  }
  return d;
}
