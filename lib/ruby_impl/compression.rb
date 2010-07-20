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

  class BitArray
    def initialize
      @array = []
      @end_bit = 0
      @start_bit = 0
    end

    def size
      @end_bit + @start_bit
    end

    def empty?
      size == 0
    end

    def to_s
      @array.pack('N*').unpack('B*').join[@start_bit...@end_bit]
    end

    # Add a bit to the end of the bit array.  Bits may be anything that
    # evaluates to either 1 or 0. Anything else is undefined.  If you can't
    # afford zeros and only have the letter O, amazingly, that works too.
    def push bit
      @array.push 0 if @array.size <= @end_bit / 32
      @array[-1] = set_bit(@array.last, @end_bit % 32) if bit == 1
      @end_bit +=1
    end

    # Our bit array is packed into an array of 32 bit integers.  This
    # function sets the ith bit of an integer.
    def set_bit integer, i
      integer | 0x80000000 >> i
    end

    # Returns the first bit and removes it, shifting all bits by one.
    def shift
      bit = @array.first[@start_bit]
      if @start_bit == 31
        @start_bit = 0
        @end_bit -= 32
        @array.shift
      else
        @start_bit += 1
      end
      bit
    end

    # Returns the ith bit of the array.
    def [] i
      @array[i/32][i % 32]
    end
  end

  # Takes disassembled floats and compresses them.  We want them dissassembled
  # because compressing exponents and signs have you unique properties and can
  # be efficiently compressed with rice coding.  The same is not true of the
  # significand.
  class GolombRiceEncoder
    def initialize m = 8
      @M = m
      @b = Math.log2(m).to_i
    end
    def << data
      data.map do |b,e,s|
        exp_sign_combo = b |(e << 1)
        [interleave(exp_sign_combo), s]
      end
    end

    # Map negative nubers to odd postive numbers and postive numbers to even
    # positive numbers.  We need to do this because negative numbers don't
    # compress well with rice encoding.
    def interleave x
      x < 0 ? 2 * x.abs - 1 : 2 * x.abs
    end

    # Rice encoding returned as a BitArray.
    def encode integer_array
      integer_array = integer_array.clone
      bits = BitArray.new
      integer_array.each do |x|
        q = x/@M
        q.times {bits.push 1}
        bits.push 0
        r = x % @M
        (@b-1).downto(0){|i| bits.push r[i]}
      end
      bits
    end
  end

  class GolombRiceDecoder
    def initialize m = 8
      @M = m
    end
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

    def decode bits
      int_array = []
    puts "bit array = #{bits}"
      while !bits.empty?
        q = 0
        nr = 0
        q+=1 while bits.shift == 1
        Math.log2(@M).to_i.times do |a|
          nr += 1 << a if bits.shift == 1
        end
        nr += q * @M
        puts "nr = #{nr}"
        int_array.push nr
      end
      int_array.reverse
    end
  end

  class NullCompressor
    def << data
      data
    end
  end
end
