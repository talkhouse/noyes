module Noyes
  class LogCompressor
    def initialize log_zero = -0.00001
      @log_zero = log_zero
    end
    def << mspec
      mspec.map {|msp| msp.map { |m|  m > 0 ? Math::log(m) : @log_zero}}
    end
  end
end
