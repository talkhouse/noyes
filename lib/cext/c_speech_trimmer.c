#include "c_noyes.h"
#undef TRUE
#define TRUE 1
#undef FALSE
#define FALSE 0

SpeechTrimmer * new_speech_trimmer(int frequency) {
  SpeechTrimmer *self = malloc(sizeof(SpeechTrimmer));
  self->leader = 5;
  self->trailer = 5;
  self->speech_started = FALSE;
  self->bcm = bent_cent_marker_new(10, 0.003, 1.0, 100.0, 0.0, 0.0);
  self->false_count = 0;
  self->true_count = 0;
  self->queue = c_list_new();
  self->eos_reached = FALSE;
  self->scs = 20;
  self->ecs = 50;
  self->seg = new_segmenter(frequency/100, frequency/100);
  return self;
}

void speech_trimmer_free(SpeechTrimmer *self) {
  bent_cent_marker_free(self->bcm);
  segmenter_free(self->seg);
  c_list_free(self->queue);
  free(self);
}

Cmat * speech_trimmer_apply(SpeechTrimmer *self, Carr* pcm) {
  if (self->eos_reached)
    return NULL;

  Cmat *segment_matrix = segmenter_apply(self->seg, pcm);
  if (segment_matrix == NULL)
	  return NULL;
  int centisecond_count = segment_matrix->rows;
  Carr **segments = mat2arrs(segment_matrix);
  Carr ** speech_segments = malloc(sizeof(Cmat*) * centisecond_count);
  int speech_count = 0, i;
  for (i=0; i<centisecond_count ;++i) {
    speech_trimmer_enqueue(self, segments[i]);
    Carr *centispeech = speech_trimmer_dequeue(self);
    while (centispeech != NULL) {
      speech_segments[speech_count++] = centispeech;
      centispeech = speech_trimmer_dequeue(self);
    }
    if (speech_trimmer_eos(self))
      break;
  }

  if (speech_trimmer_eos(self) && speech_count == 0) {
    free(speech_segments);
    return NULL;
  }

  return arrs2mat(speech_segments, speech_count);
}


void speech_trimmer_enqueue(SpeechTrimmer *self, Carr* pcm) {
  if (self->eos_reached)
    return;
  c_list_add(self->queue, pcm);
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
      int new_size = c_list_size(self->queue) - self->ecs + self->trailer;
      int i;
      for (i=new_size; i<c_list_size(self->queue); ++i)
        narr_free(c_list_get(self->queue, i));

      c_list_remove(self->queue, new_size, c_list_size(self->queue));
    }
  } else if (self->true_count > self->scs) {
    if (self->leader + self->scs < c_list_size(self->queue)) {
      int start = c_list_size(self->queue) - self->leader - self->scs - 1;
      int i;
      for (i=0; i<start; ++i)
        narr_free(c_list_get(self->queue, i));

      c_list_remove(self->queue, 0, start);
    }
    self->speech_started = TRUE;
  }
}

Carr * speech_trimmer_dequeue(SpeechTrimmer *self) {
  if (c_list_size(self->queue) == 0)
    return NULL;
  if (self->eos_reached || (self->speech_started &&
    c_list_size(self->queue) > self->ecs)) {
    Carr * N = c_list_get(self->queue, 0);
    c_list_remove(self->queue, 0, 1);
    return N;
  }
  return NULL;
}

int speech_trimmer_eos(SpeechTrimmer *self) {
  return self->eos_reached;
}
