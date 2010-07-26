#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "c_array_list.h"

#define NLIST_INITIAL_CAPACITY 10
#define NLIST_DELTA_CAPACITY 10
#undef TRUE
#define TRUE 1
#undef FALSE
#define FALSE 0

Clist * c_list_new() {
  Clist * self;
  self = malloc(sizeof(Clist));
  self->capacity = NLIST_INITIAL_CAPACITY;
  self->data = malloc(sizeof(void*) * self->capacity);
  self->size = 0;
  return self;
}

void c_list_free(Clist * self) {
  free(self->data);
  free(self);
}

int c_list_add(Clist * self, void * object) {
  int old_size = c_list_size(self);
  int new_capacity;
  void ** new_data;

  (self->size)++;
  if (old_size == self->capacity) {
    new_capacity = self->capacity + NLIST_DELTA_CAPACITY;
    new_data = malloc(sizeof(void*) * new_capacity);
    memcpy(new_data, self->data, sizeof(void*) * old_size);
    free(self->data);
    (self->data) = new_data;
    self->capacity = new_capacity;
  }
  self->data[old_size] = object;
  return TRUE;
}

int c_list_remove(Clist * self, int start, int finish) {
  if (start > finish || finish > self->size)
    return 1;

  memmove(self->data + start, self->data + finish,
                              sizeof(void*) * (self->size - finish));
  self->size = self->size - (finish - start);
  if (self->size < self->capacity - 2 * NLIST_DELTA_CAPACITY) {
    int new_capacity = self->size + NLIST_DELTA_CAPACITY;
    self->data = realloc(self->data, sizeof(void*) * new_capacity);
    self->capacity = new_capacity;
  }
  return 0;
}

void * c_list_get(const Clist * self, const int index) {
  if (index < 0 || index > self->size)
    return NULL;
  return self->data[index];
}

int c_list_is_empty(const Clist * self) {
  return 0 == c_list_size(self);
}

int c_list_size(const Clist * self) {
  return self->size;
}
