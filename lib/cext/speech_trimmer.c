#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

static int id_push;

VALUE cSpeechTrimmer;

static void _speech_trimmer_free(void *p) {
  speech_trimmer_free(p);
}

static VALUE t_init(VALUE self, VALUE args) {
  int len = RARRAY_LEN(args);
  SpeechTrimmer *st;
  int frequency = 16000;
  double threshold = 10;
  if (len > 0)
    frequency = NUM2INT(rb_ary_entry(args, 0));
  if (len > 1)
    frequency = rb_float_new(rb_ary_entry(args, 0));

  st = new_speech_trimmer(frequency, threshold);
  VALUE stv = Data_Wrap_Struct(cSpeechTrimmer, 0, _speech_trimmer_free, st);
  rb_iv_set(self, "@speech_trimmer", stv);
  return self;
}

static VALUE t_enqueue(VALUE self, VALUE obj) {
  Carr *M = r2carr(obj);
  SpeechTrimmer *st;
  Data_Get_Struct(rb_iv_get(self, "@speech_trimmer"), SpeechTrimmer, st);
  speech_trimmer_enqueue(st, M);
  return Qnil;
}

static VALUE t_dequeue(VALUE self) {
  SpeechTrimmer *st;
  Data_Get_Struct(rb_iv_get(self, "@speech_trimmer"), SpeechTrimmer, st);
  Carr *N =speech_trimmer_dequeue(st);
  VALUE result = carr2r(N);
  narr_free(N);
  return result;
}

static VALUE t_eos(VALUE self) {
  SpeechTrimmer *st;
  VALUE stv = rb_iv_get(self, "@speech_trimmer");
  Data_Get_Struct(stv, SpeechTrimmer, st);
  return speech_trimmer_eos(st) ? Qtrue : Qfalse;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Carr *M  = r2carr(obj);
  SpeechTrimmer *st;
  Data_Get_Struct(rb_iv_get(self, "@speech_trimmer"), SpeechTrimmer, st);
  Cmat *R = speech_trimmer_apply(st, M);
  if (!R) {
    narr_free(M);
    return Qnil;
  }
  VALUE result = cmat2r(R);
  narr_free(M);
  cmat_free(R);
  return result;
}

void Init_speech_trimmer() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cSpeechTrimmer = rb_define_class_under(m_noyes_c, "SpeechTrimmer", rb_cObject);
  rb_define_method(cSpeechTrimmer, "initialize", t_init, -2);
  rb_define_method(cSpeechTrimmer, "enqueue", t_enqueue, 1);
  rb_define_method(cSpeechTrimmer, "dequeue", t_dequeue, 0);
  rb_define_method(cSpeechTrimmer, "eos?", t_eos, 0);
  rb_define_method(cSpeechTrimmer, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
