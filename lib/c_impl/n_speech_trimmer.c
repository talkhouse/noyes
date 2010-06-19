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
  free(self);
}

void speech_trimmer_enqueue(SpeechTrimmer *self, NMatrix1* pcm) {
  n_list_add(self->queue, pcm);
}

NMatrix1 * speech_trimmer_dequeue(SpeechTrimmer *self) {
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
