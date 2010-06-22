module Noyes
  # SpeechTrimmer trims non-speech from both ends of an audio stream. Each time
  # you enqueue audio into it you should dequeue audio out of it until dequeue
  # returns nil.  Then check for eos.  If eos is true you are done.
  # SpeechTrimmer is designed to work efficiently with live audio.
  class SpeechTrimmer
    def initialize
      @leader = 5  # Cents of leading silence to retain.
      @trailer = 5  # Cents of trailing silence to retain.
      @speech_started = false
      @cent_marker = BentCentMarker.new
      @false_count=0
      @true_count=0
      @queue = []
      @eos_reached = false
      @scs = 20 # Centiseconds of speech before detection of utterance.
      @ecs = 50 # Centiseconds of silence before end detection.
    end

    def enqueue pcm
      return if @eos_reached
      @queue << pcm
      if @cent_marker << pcm
        @false_count = 0
        @true_count += 1
      else
        @false_count += 1
        @true_count = 0
      end
      if @speech_started
        if @false_count == @ecs
          @eos_reached = true
          # only keep trailer number of cents once eos is detected.
          @queue = @queue[0, @queue.size - @ecs + @trailer]
        end
      elsif @true_count > @scs
        # Discard most begining silence, keeping just a tad.
        if @leader + @scs < @queue.size
          start = @queue.size - @leader - 1 - @scs
          @queue = @queue[start,@queue.size - start]
        end
        @speech_started = true
      end
    end
    def dequeue
      if @eos_reached || (@speech_started && @queue.size > @ecs)
        @queue.shift
      end
    end
    def eos?
      @eos_reached
    end
  end    
end
