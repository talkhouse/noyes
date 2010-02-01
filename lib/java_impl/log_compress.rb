module Signal
  class LogCompressor
    def initialize log_zero = -0.00001
      @compressor = Java::talkhouse.LogCompressor.new log_zero
    end
    def << mspec
      x = @compressor.apply mspec.to_java Java::double[]
      x.map{|a|a.to_a}
    end
  end
end
