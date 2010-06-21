#include "ruby.h"
#include "noyes.h"
#include "rnoyes.h"

static int id_push;

VALUE cArrayList;

static void free_n_list(void *p) {
  n_list_free(p);
}

static VALUE t_init(VALUE self) {
  NList *st = n_list_new();
  VALUE stv = Data_Wrap_Struct(cArrayList, 0, free_n_list, st);
  rb_iv_set(self, "@n_list", stv);
  return self;
}

static VALUE t_size(VALUE self) {
  NList *array;
  VALUE arrayv = rb_iv_get(self, "@n_list");
  Data_Get_Struct(arrayv, NList, array);
  return INT2FIX(n_list_size(array));
}

static VALUE t_add(VALUE self, VALUE obj) {
  NList *array;
  VALUE arrayv = rb_iv_get(self, "@n_list");
  Data_Get_Struct(arrayv, NList, array);
  n_list_add(array, (void*)obj);
  return Qnil;
}

static VALUE t_get(VALUE self, VALUE obj) {
  NList *array;
  VALUE arrayv = rb_iv_get(self, "@n_list");
  Data_Get_Struct(arrayv, NList, array);
  return (VALUE)n_list_get(array, FIX2INT(obj));
}

static VALUE t_remove(VALUE self, VALUE start, VALUE finish) {
  NList *array;
  VALUE arrayv = rb_iv_get(self, "@n_list");
  Data_Get_Struct(arrayv, NList, array);
  int b = FIX2INT(start);
  int e = FIX2INT(finish);
  if (n_list_remove(array, b, e)) {
    int s = n_list_size(array);
    rb_raise(rb_eArgError, "start = %d, finish = %d with size =  %d", b, e, s);
   }
  return Qnil;
}

void Init_n_list() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cArrayList = rb_define_class_under(m_noyes_c, "ArrayList", rb_cObject);
  rb_define_method(cArrayList, "initialize", t_init, 0);
  rb_define_method(cArrayList, "size", t_size, 0);
  rb_define_method(cArrayList, "add", t_add, 1);
  rb_define_method(cArrayList, "get", t_get, 1);
  rb_define_method(cArrayList, "remove", t_remove, 2);
  id_push = rb_intern("push");
}
