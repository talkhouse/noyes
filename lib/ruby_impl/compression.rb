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
        signbit = bits >> 31
        exponent = (bits & 0x7F800000) >> 23
        significand = bits & 0x007FFFFF
        [signbit, exponent - 127, significand]
    end
    end
  end

  class FloatAssembler
    def << data
      data.map do |signbit, exponent, significand|
        bits = signbit << 31 | 127 + exponent << 23 | significand
      end.pack('N*').unpack('g*')
    end
  end

  class GolumbRiceEncoder
    def << data
      data.map do |b,e,s|
        exp_sign_combo = b |(e << 1)
        [interleave(exp_sign_combo), s]
      end
    end

    # Map negative nubers to odd postive numbers and postive numbers to even
    # positive numbers
    def interleave x
      x < 0 ? 2 * x.abs - 1 : 2 * x.abs
    end
  end

  class GolumbRiceDecoder
    def << data
      data.map do |exp_sign_combo, significand|
        exp_sign_combo = deinterleave exp_sign_combo
        sign = exp_sign_combo & 0x00000001
        exp =  exp_sign_combo >> 1
        [sign, exp, significand]
      end
    end
    def deinterleave x
      x.odd? ? (x + 1)/-2 : x/2
    end
  end

  class NullCompressor
    def << data
      data
    end
  end
end
