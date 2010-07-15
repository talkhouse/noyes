#ifndef _N_ARRAY_LIST_H_
#define _N_ARRAY_LIST_H_

typedef struct {
  int capacity;
  void **data;
  int size;
} NList;

NList * c_list_new();
void c_list_free(NList * self);
int c_list_size(const NList * self);
int c_list_add(NList * self, void * object);
int c_list_remove(NList * self, int start, int finish);
void * c_list_get(const NList * self, const int index);
int c_list_is_empty(const NList * self);

#endif
