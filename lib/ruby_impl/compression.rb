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

  class FloatSplitter
    def << data
      data.pack('g*').unpack('N*').map do |bits|
        signbit = bits & 0x80000000 >> 31
        exponent = (bits & 0x7F800000) >> 23
        significand = (bits & 0x007FFFFF)
        [signbit, exponent, significand]
    end
    end
  end

  class FloatAssembler
    def << data
      data.map do |signbit, exponent, significand|
        bits = (signbit << 31) | (exponent << 23) | significand
      end.pack('N*').unpack('g*')
    end
  end

  class NullCompressor
    def << data
      data
    end
  end
end
