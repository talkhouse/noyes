module Noyes
  # Segments an array of data into an array of arrays.  Inner arrays are the
  # size of the window.  The segmenter will not return less than three
  # segments at a time.
  #
  # if combolen >= winsize:
  #    combolen = winsize + winshift * (numsegs - 1) + comblen % winshift
  # else
  #   combolen = 0
  #
  # From this we have:
  # combolen - combolen % winshift - winsize = winshift * numsegs - winshift
  # numsegs = (combolen - combolen % winshift - winsize + winshift)/winshift
  class Segmenter
    @@MIN_SEGMENTS = 3
    def initialize window_size, shift
      @winsz = window_size; @winshift = shift
      @overflow = nil
    end    
    def << data
      data = @overflow + data if @overflow
      if data.size < @winsz + @winshift * @@MIN_SEGMENTS
        @overflow = data
        return nil 
      else
        @overflow = nil 
      end
      segments = []
      offset = 0
      while offset + @winsz <= data.length
        segments << data[offset, @winsz]
        offset += @winshift
      end
      @overflow = data[offset..-1]
      segments
    end
  end
end
