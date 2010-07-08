// Wrapper stuff.  Only ruby related stuff below here.
#include "ruby.h"
void Init_preemphasis();
void Init_segmenter();
void Init_hamming_window();
void Init_power_spectrum();
void Init_mel_filter();
void Init_log_compressor();
void Init_live_cmn();
void Init_fast_8k_mfcc();
void Init_dct();
void Init_bent_cent_marker();
void Init_speech_trimmer();
void Init_c_list();

VALUE nmatrix_2_v(Nmat *d);
Nmat * v_2_nmatrix(VALUE value);

VALUE nmatrix1_2_v(Narr *d);
Narr * v_2_nmatrix1(VALUE value);
