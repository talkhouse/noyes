// Wrapper stuff.  Only ruby related stuff below here.
#include "ruby.h"
void Init_preemphasis();
void Init_segmenter();
void Init_hamming_window();
void Init_power_spectrum();
void Init_mel_filter();
void Init_log_compressor();
void Init_live_cmn();

VALUE nmatrix_2_v(NMatrix *d);
NMatrix * v_2_nmatrix(VALUE value);

VALUE nmatrix1_2_v(NMatrix1 *d);
NMatrix1 * v_2_nmatrix1(VALUE value);
