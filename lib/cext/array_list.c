#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

static int id_push;

VALUE cArrayList;

static void free_c_list(void *p) {
  c_list_free(p);
}

static VALUE t_init(VALUE self) {
  NList *st = c_list_new();
  VALUE stv = Data_Wrap_Struct(cArrayList, 0, free_c_list, st);
  rb_iv_set(self, "@c_list", stv);
  return self;
}

static VALUE t_size(VALUE self) {
  NList *array;
  VALUE arrayv = rb_iv_get(self, "@c_list");
  Data_Get_Struct(arrayv, NList, array);
  return INT2FIX(c_list_size(array));
}

static VALUE t_add(VALUE self, VALUE obj) {
  NList *array;
  VALUE arrayv = rb_iv_get(self, "@c_list");
  Data_Get_Struct(arrayv, NList, array);
  c_list_add(array, (void*)obj);
  return Qnil;
}

static VALUE t_get(VALUE self, VALUE obj) {
  NList *array;
  VALUE arrayv = rb_iv_get(self, "@c_list");
  Data_Get_Struct(arrayv, NList, array);
  return (VALUE)c_list_get(array, FIX2INT(obj));
}

static VALUE t_remove(VALUE self, VALUE start, VALUE finish) {
  NList *array;
  VALUE arrayv = rb_iv_get(self, "@c_list");
  Data_Get_Struct(arrayv, NList, array);
  int b = FIX2INT(start);
  int e = FIX2INT(finish);
  if (c_list_remove(array, b, e)) {
    int s = c_list_size(array);
    rb_raise(rb_eArgError, "start = %d, finish = %d with size =  %d", b, e, s);
   }
  return Qnil;
}

void Init_c_list() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cArrayList = rb_define_class_under(m_noyes_c, "ArrayList", rb_cObject);
  rb_define_method(cArrayList, "initialize", t_init, 0);
  rb_define_method(cArrayList, "size", t_size, 0);
  rb_define_method(cArrayList, "add", t_add, 1);
  rb_define_method(cArrayList, "get", t_get, 1);
  rb_define_method(cArrayList, "remove", t_remove, 2);
  id_push = rb_intern("push");
}
