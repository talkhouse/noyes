#include "noyes.h"
#undef TRUE
#define TRUE 1
#undef FALSE
#define FALSE 0

SpeechTrimmer * new_speech_trimmer() {
  SpeechTrimmer *self = malloc(sizeof(SpeechTrimmer));
  self->leader = 5;
  self->trailer = 5;
  self->speech_started = FALSE;
  self->bcm = new_bent_cent_marker();
  self->false_count = 0;
  self->true_count = 0;
  self->queue = n_list_new();
  self->eos_reached = FALSE;
  self->scs = 20;
  self->ecs = 50;
  return self;
}

void free_speech_trimmer(SpeechTrimmer *self) {
  free_bent_cent_marker(self->bcm);
  n_list_free(self->queue);
  free(self);
}

void speech_trimmer_enqueue(SpeechTrimmer *self, NMatrix1* pcm) {
  if (self->eos_reached)
    return;
  n_list_add(self->queue, pcm);
  if (bent_cent_marker_apply(self->bcm, pcm)) {
    self->false_count = 0;
    self->true_count += 1;
  } else {
    self->false_count += 1;
    self->true_count = 0;
  }
  if (self->speech_started) {
    if (self->false_count == self->ecs) {
      self->eos_reached = TRUE;
      int new_size = n_list_size(self->queue) - self->ecs + self->trailer;
      n_list_remove(self->queue, new_size, n_list_size(self->queue));
    }
  } else if (self->true_count > self->scs) {
    if (self->leader + self->scs < n_list_size(self->queue)) {
      int start = n_list_size(self->queue) - self->leader - self->scs - 1;
      n_list_remove(self->queue, 0, start);
    }
    self->speech_started = TRUE;
  }
}

NMatrix1 * speech_trimmer_dequeue(SpeechTrimmer *self) {
  if (n_list_size(self->queue) == 0)
    return NULL;
  if (self->eos_reached || (self->speech_started &&
      n_list_size(self->queue) > self->ecs)) {
    NMatrix1 * N = n_list_get(self->queue, 0);
    n_list_remove(self->queue, 0, 1);
    return N;
  }
  return NULL;
}
int speech_trimmer_eos(SpeechTrimmer *self) {
  return self->eos_reached;
}
