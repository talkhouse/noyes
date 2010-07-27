module Noyes
  # Segments an array of data into an array of arrays.  Inner arrays are the
  # size of the window.  The segmenter will not return less than three
  # segments at a time.  Here is the forumla for determining the number
  # of segments produced by an array of data:
  #
  # if combolen >= winsize:
  #   nsegs = 1 + (arrlen - wsize - (arrlen - wise) % shift)/shift
  # else
  #   combolen = 0
  #
  # This formula is derived from the following equation:
  # arrlen = wsize + shift (nsegs - 1) + (arrlen - wsize) % shift
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
