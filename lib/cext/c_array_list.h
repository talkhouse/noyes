#ifndef _N_ARRAY_LIST_H_
#define _N_ARRAY_LIST_H_

typedef struct {
  int capacity;
  void **data;
  int size;
} Clist;

Clist * clist_new();
void clist_free(Clist * self);
int clist_size(const Clist * self);
int clist_add(Clist * self, void * object);
int clist_remove(Clist * self, int start, int finish);
void * clist_get(const Clist * self, const int index);
int clist_is_empty(const Clist * self);

#endif
