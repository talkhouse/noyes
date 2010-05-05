#include "ruby.h"
#include "noyes.h"

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
//  rb_iv_set(self, "@segmenter", segmenter);

  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  int len = RARRAY_LEN(obj);
  int *ptr = (int*)RARRAY_PTR(obj);
  int i;
  double *data = ALLOC_N(double, len);
  for (i=0;i<len;++i) {
    data[i] = NUM2DBL(ptr[i]);
  }
  VALUE segmenter = rb_iv_get(self, "@segmenter");
  Segmenter *s;
  Data_Get_Struct(segmenter, Segmenter, s);
  NData2 *d = segmenter_apply(s, data, len);
  VALUE result = rb_ary_new2(d->rows);
  for (i=0;i<d->rows;++i) {
    VALUE row = rb_ary_new2(d->cols);
    int j;
    for (j=0;j<d->cols;++d) {
      rb_ary_store(row, j, rb_float_new(d->data[i][j]));
    }
  }
  free_ndata2(d);

  return result;
}


void Init_segmenter() {
  fprintf(stderr, "initialising this thing");
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cSegmenter = rb_define_class_under(m_noyes_c, "Segmenter", rb_cObject);
  rb_define_method(cSegmenter, "initialize", t_init, -2);
  rb_define_method(cSegmenter, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}

