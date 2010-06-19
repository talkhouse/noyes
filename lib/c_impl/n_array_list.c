#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "n_array_list.h"

#define NLIST_INITIAL_CAPACITY 10
#define NLIST_DELTA_CAPACITY 10
#undef TRUE
#define TRUE 1
#undef FALSE
#define FALSE 0

NList * n_list_new() {
  NList * self;
  self = malloc(sizeof(NList));
  self->capacity = NLIST_INITIAL_CAPACITY;
  self->data = malloc(sizeof(void*) * self->capacity);
  self->size = 0;
  return self;
}

void n_list_free(NList * self) {
  free(self->data);
  free(self);
}

int n_list_add(NList * self, void * object) {
  int old_size = n_list_size(self);
  int new_capacity;
  void ** new_data;

  (self->size)++;
  if (old_size == self->capacity)
    {
      new_capacity = self->capacity + NLIST_DELTA_CAPACITY;
      new_data = malloc(sizeof(void*) * new_capacity);
      memcpy(new_data, self->data, sizeof(void*) * old_size);
      free(self->data);
      (self->data) = new_data;
      self->capacity = new_capacity;
    }
  (self->data)[old_size] = object;
  return TRUE;
}

void n_list_remove(NList * self, int start, int finish) {
  int length = n_list_size(self);
  memmove(self->data + start, self->data + finish, sizeof(void*) * (length - finish));
  self->size = self->size - (finish - start);
  if (self->size < self->capacity - 2 * NLIST_DELTA_CAPACITY) {
    int new_capacity = self->size + NLIST_DELTA_CAPACITY;
    self->data = realloc(self->data, sizeof(void*) * new_capacity);
    self->capacity = new_capacity;
  }
}

void * n_list_get(const NList * self, const int index) {
  return self->data[index];
}

int n_list_contains(const NList * self, const void * object) {
  return (n_list_index_of(self, object) > -1);
}

int n_list_is_empty(const NList * self) {
  return 0 == n_list_size(self);
}

int n_list_size(const NList * self) {
  return self->size;
}
