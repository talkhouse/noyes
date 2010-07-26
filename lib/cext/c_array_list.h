#ifndef _N_ARRAY_LIST_H_
#define _N_ARRAY_LIST_H_

typedef struct {
  int capacity;
  void **data;
  int size;
} Clist;

Clist * c_list_new();
void c_list_free(Clist * self);
int c_list_size(const Clist * self);
int c_list_add(Clist * self, void * object);
int c_list_remove(Clist * self, int start, int finish);
void * c_list_get(const Clist * self, const int index);
int c_list_is_empty(const Clist * self);

#endif
