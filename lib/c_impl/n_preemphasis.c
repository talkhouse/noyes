#include "noyes.h"

Preemphasizer * new_preemphasizer(double factor) {
  Preemphasizer *self = malloc(sizeof(Preemphasizer));
  self->factor = factor;
  self->prior = 0;
  return self;
}

void free_preemphasizer(Preemphasizer *self) {
  free(self);
}

NMatrix1 *preemphasizer_apply(Preemphasizer *self, NMatrix1 *data) {
    NMatrix1 *res = new_nmatrix1(data->rows);
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
