module Noyes
  class LiveCMN
    # Normalizes cepstrum means and applies them.  Dimensionality remains
    # unchanged.  NOTE:  This class resets itself automatically if bounds drift
    # too much.  Possibly these bounds should be parameterized.
    def initialize dimensions=13, init_mean=45.0, window_size=100, shift=160
      @init_mean = init_mean; @shift = shift; @ws = window_size
      @sums = Array.new dimensions, 0
      @means = Array.new dimensions, 0
      @means[0] = @init_mean
      @frame_count = 0
    end
    def << dct
      raise "Wrong number of dimensions" if dct[0].size != @means.size
      dct.map do |mfc|
        cmn = Array.new @means.size
        @means.size.times do |i|
          @sums[i] += mfc[i]
          cmn[i] = mfc[i] - @means[i]
        end
        @frame_count += 1
        update if @frame_count > @shift
        cmn
      end
    end
    def update
      per_frame = 1.0 / @frame_count
      @means = @sums.map {|x| x * per_frame}
      
      if @means.first > 70 || @means.first < 5
        reset
      elsif @frame_count >= @shift
        @sums = @sums.map {|x| x * per_frame * @ws}
        @frame_count = @ws
      end
    end
    def reset
      @sums.map! {0}
      @means.map! {0}
      @means[0] = @init_mean
      @frame_count = 0
    end
  end
end
