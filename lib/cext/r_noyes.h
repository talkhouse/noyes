// Wrapper stuff.  Only ruby related stuff below here.
#include "ruby.h"
void Init_preemphasis();
void Init_segmenter();
void Init_hamming_window();
void Init_power_spectrum();
void Init_mel_filter();
void Init_log_compressor();
void Init_live_cmn();
void Init_mfcc_16x8();
void Init_dct();
void Init_bent_cent_marker();
void Init_speech_trimmer();
void Init_c_list();

VALUE cmat2r(Cmat *d);
Cmat * r2cmat(VALUE value);

VALUE carr2r(Carr *d);
Carr * r2carr(VALUE value);
