#include "c_noyes.h"
#include "stdlib.h"
#include "stdio.h"

LiveCMN * live_cmn_new(int dimensions, double init_mean, int window_size,
                                                         int shift) {
  LiveCMN *cmn = malloc(sizeof(LiveCMN));
  cmn->init_mean = init_mean; 
  cmn->window_size = window_size;
  cmn->shift = shift;
  cmn->sums = calloc(dimensions, sizeof(double));
  cmn->dimensions = dimensions;
  cmn->means = calloc(dimensions, sizeof(double));
  cmn->means[0] = init_mean;
  cmn->frame_count=0;
  return cmn;
}

void live_cmn_free(LiveCMN *cmn) {
  free(cmn->sums);
  free(cmn->means);
  free(cmn);
}

static void live_cmn_reset(LiveCMN *self) {
    int i;
    for (i=0; i<self->dimensions; ++i) {
        self->sums[i] = 0.0;
    }
    for (i=0; i<self->dimensions; ++i) {
        self->means[i] = 0.0;
    }
    self->means[0] = self->init_mean;
    self->frame_count = 0;
}

static void live_cmn_update(LiveCMN *self) {
    double per_frame = 1.0 / self->frame_count;
    int i;
    for (i=0; i< self->dimensions; ++i) {
        self->means[i] = self->sums[i] * per_frame;
    }
    
    if (self->means[0] > 70 || self->means[0] < 5) {
        live_cmn_reset(self);
    } else if (self->frame_count >= self->shift) {
        for (i=0; i < self->dimensions; ++i) {
            self->sums[i] = self->sums[i] * per_frame * self->window_size;
            self->frame_count = self->window_size;
        }
    }
}

Cmat *live_cmn_apply(LiveCMN *self, Cmat *dct) {
  if (dct->cols != self->dimensions) {
      fprintf(stderr, "Wrong number of dimensions in live_cmn_apply\n");
      return NULL;
  }
  Cmat *cmn = cmat_new(dct->rows, dct->cols);
  int i,j;
  for (i=0;i<dct->rows;++i) {
      for (j=0;j<dct->cols;++j) {
          self->sums[j] += dct->data[i][j];
          cmn->data[i][j] = dct->data[i][j] - self->means[j];
      }
      ++self->frame_count;
      if (self->frame_count > self->shift) {
        live_cmn_update(self);
      }
  }
  return cmn;
}
