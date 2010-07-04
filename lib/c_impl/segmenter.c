#include "ruby.h"
#include "noyes.h"
#include "rnoyes.h"

static int id_push;

VALUE cSegmenter;

static void segmenter_free(void *p) {
  free_segmenter(p);
}
static VALUE t_init(VALUE self, VALUE args) {
  int winsz = 205;
  int winshift = 80;
  int len = RARRAY_LEN(args);
  if (len > 0) {
     winsz = NUM2INT(rb_ary_entry(args, 0));
  }
  if (len > 1) {
    winshift = NUM2INT(rb_ary_entry(args, 1));
  }

  Segmenter *s = new_segmenter(winsz, winshift);
  VALUE segmenter = Data_Wrap_Struct(cSegmenter, 0, segmenter_free, s);
  rb_iv_set(self, "@segmenter", segmenter);

  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Narr *M = v_2_nmatrix1(obj); 
  VALUE segmenter = rb_iv_get(self, "@segmenter");
  Segmenter *s;
  Data_Get_Struct(segmenter, Segmenter, s);
  Nmat *N = segmenter_apply(s, M);
  VALUE result = nmatrix_2_v(N);
  nmat_free(N);
  nmat_free1(M);
  return result;
}

void Init_segmenter() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cSegmenter = rb_define_class_under(m_noyes_c, "Segmenter", rb_cObject);
  rb_define_method(cSegmenter, "initialize", t_init, -2);
  rb_define_method(cSegmenter, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
