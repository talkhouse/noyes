module Signal
  class HammingWindow
    include Math
    def initialize window_size
  	  twopi = 2 * PI
  	  @hamming_window = []
      window_size.times do |i|
  	  	@hamming_window << 0.54 - 0.46*cos(twopi*i/(window_size-1))
  	  end
    end
    def << segments
      segments.map do |s|
        s.zip(@hamming_window).map {|d, h| d*h}
      end
    end
  end
end
