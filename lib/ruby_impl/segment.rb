# Segments an array of data into an array of arrays.  Since the inner array
# used to hold a segment is created with the [] slice operator it would
# typically be of the same type as the input array.  So Java arrays remain Java
# arrays for example.  This is good for speed.  Typically, we'd want a window
# size of 410 samples.  This corresponds to a 25.625 millisecond window in a
# 16khz audio stream.
module Noyes
  class Segmenter
    def initialize winsz, winshift
      @winsz = winsz; @winshift = winshift
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
      x = []
      i = 0
      while i+@winsz <= data.length
        x << data[i,@winsz]
        i += @winshift
      end
      @overflow = data[i..-1]
      x
    end
  end
end
