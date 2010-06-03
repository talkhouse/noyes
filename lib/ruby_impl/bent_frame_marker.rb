module Noyes
  # Determines whether a PCM frame is speech or not using Bent
  # Schmidt-Nielsen's algorithm.  Basically, it's an energy-based detector
  # where the background noise level is constantly estimated.
  #
  # The pcm data should be in 100 millisecond chunks.  For example,
  # At 8000 Hz there should 80 frames of pcm.
  class BentFrameMarker
    def initialize
      @adjustment = 0.003
      @average_number = 1.0
      @background = 100.0
      @level = 0.0
      @min_signal = 0.0
      @threshold = 10.0
    end
    def logrms pcm
      sum_of_squares = 0.0
      pcm.each {|sample| sum_of_squares += sample * sample}
      rms = Math.sqrt sum_of_squares / pcm.size;
      rms = Math.max rms, 1
      Math.log(rms) * 20
    end
    def << pcm
      current = logrms pcm
      is_speech = false
      if current >= @min_signal
        @level = ((@level * @average_number) + current) / (@average_number + 1)
        if current < @background 
          @background = current
        else
          @background += (current - @background) * @adjustment
        end
        @level = @background if (@level < @background)
        is_speech = @level - @background > @threshold
      end
      is_speech
    end
  end
end
