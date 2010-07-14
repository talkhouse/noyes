#include "c_noyes.h"
#include "math.h"
#include "stdlib.h"

BentCentMarker * bent_cent_marker_new(double threshold, double adjustment,
                                      double average_number, double background,
                                      double level, double min_signal) {
  BentCentMarker *self = malloc(sizeof(BentCentMarker));
  self->adjustment = adjustment;
  self->average_number = average_number;
  self->background = background;
  self->level = level;
  self->min_signal = min_signal;
  self->threshold = threshold;
  return self;
}

void bent_cent_marker_free(BentCentMarker *self) {
  free(self);
}

double bent_cent_log_rms(BentCentMarker *self, Carr *pcm) {
  double sum_of_squares = 0.0;
  int i;
  for (i=0;i<pcm->rows;++i) {
    sum_of_squares += pcm->data[i] * pcm->data[i];
  }
  double rms = sqrt(sum_of_squares/pcm->rows);
  rms = fmax(rms,1.0);
  return log(rms) * 20;
}

int bent_cent_marker_apply(BentCentMarker *self, Carr *pcm) {
  int is_speech = 0;
  double current = bent_cent_log_rms(self, pcm);
  if (current >= self->min_signal) {
    self->level = ((self->level * self->average_number) + current) /
                   (self->average_number + 1);
    if (current < self->background) {
      self->background = current;
    } else {
      self->background += (current - self->background) * self->adjustment;
    }
    if (self->level < self->background) {
      self->level = self->background;
    }
    is_speech = self->level - self->background > self->threshold;
  }
  return is_speech;
}
