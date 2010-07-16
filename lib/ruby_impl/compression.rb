module Noyes
  
  class ULaw
    def << data
      result = data.map do |cmn|
        cmn.map do |x|
          e2x = Math::E ** x.abs
          Math.log(1 + 255 * e2x) / Math.log(1 + e2x)
        end
      end
    end
  end

  class Compressor
    def << data
      @last = Array.new(data.first.size){0.0} unless @last
      result = data.map do |signal|
        signal.zip(@last).map do |both|
          both[0] - both[1]
        end
      end
      @last = data.last
      result
    end
  end

  class DeltaEncoder
    def initialize dimensions=13
      @dimensions = dimensions
      @delta = Array.new dimensions, 0.0
    end

    def << data
      data.each_slice(@dimensions).map do |array|
        array.each_with_index.map do |element, index|
          current_delta = @delta[index]
          @delta[index] = element
          element - current_delta
        end
      end
    end
  end

  class DeltaDecoder
    def initialize dimensions=13
      @dimensions = dimensions
      @delta = Array.new dimensions, 0.0
    end

    def << data
      data.each_slice(@dimensions).map do |array|
        array.each_with_index.map do |element, index|
          @delta[index] += element
        end
      end
    end
  end

  class NullCompressor
    def << data
      delta = 0
      deltas = data.each_slice(13).map do |x|
        o = x[0]
        z= x[0]
        z -= delta
        delta=x[0]
        z
      end
      puts deltas.pack('g*').unpack('B*')[0].scan(/................................/)
      data
    end
  end
end
