module Noyes
  class SpeechTrimmer
    def initialize
      @speech_leader = 1
      @speech_trailer = 1
      @speech_started = false
      @frame_count = 0
      @speech_started = false
      @frame_marker = BentFrameMarker.new
      @false_count=0
      @speech_queue = []
      @eos_reached = false
    end

    def << pcm
      @speech_queue << pcm
      if @frame_marker << pcm # is the 10 ms speech?
        @false_count = 0
        unless @speech_started
          # Discard most begining silence, keeping just a tad.
          if @speech_leader < @speech_queue.size
            @speech_queue = @speech_queue[-@speech_leader - 1, @speech_leader + 1]
          end
          @speech_started = true
        end
      else
        @false_count += 1
      end
      if @false_count >= 40
        @eos_reached = true
        # only keep trailer number of frames once eos is detected.
        @speech_queue = @speech_queue.slice 0, @speech_trailer
      end
      @speech_queue.shift if @speech_started
    end
    def eos?
      @eos_reached
    end
    def get_queue
      @speech_queue
    end
  end    
end
      
