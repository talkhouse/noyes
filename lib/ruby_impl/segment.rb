module Noyes
  # Segments an array of data into an array of arrays.  Inner arrays are the
  # size of the window.
  class Segmenter
    def initialize window_size, shift
      @winsz = window_size; @winshift = shift
      @overflow = nil
    end    
    def << data
      data = @overflow + data if @overflow
      if data.size < @winsz + @winshift * 5
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
