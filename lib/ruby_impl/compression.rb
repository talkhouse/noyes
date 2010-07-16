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

  class NullCompressor
    def << data
      data
    end
  end
end
