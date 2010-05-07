#include "ruby.h"
#include "noyes.h"

HammingWindow * new_hamming_window(int window_size) {
  HammingWindow *hw = malloc(sizeof(HammingWindow));
  hw->buf = malloc(window_size * sizeof(double));
  hw->buflen = window_size;
  return hw;
}

void free_hamming_window(HammingWindow *hw) {
  free(hw->buf);
  free(hw);
}

NMatrix * hamming_window_apply(HammingWindow *self, NMatrix* data) {
  return NULL;
}
