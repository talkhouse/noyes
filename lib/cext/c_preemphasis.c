#include "c_noyes.h"

Preemphasizer * new_preemphasizer(double factor) {
  Preemphasizer *self = malloc(sizeof(Preemphasizer));
  self->factor = factor;
  self->prior = 0;
  return self;
}

void free_preemphasizer(Preemphasizer *self) {
  free(self);
}

Carr *preemphasizer_apply(Preemphasizer *self, Carr *data) {
    Carr *res = narr_new(data->rows);
    double current_prior = self->prior;
    self->prior = data->data[data->rows-1];
    int i;
    for (i = 0; i < data->rows; ++i) {
        double current = data->data[i];
        res->data[i] = current - self->factor * current_prior;
        current_prior = current;
    }
    return res;
}
