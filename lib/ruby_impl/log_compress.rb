module Noyes
  # Takes the log base 10 of an incoming m x n array.  The dimensions of the
  # array remain unchanged.  If a value is zero then the value log_zero is used
  # instead of plunging into singularity land and throwing an exception.
  class LogCompressor
    def initialize log_zero = -0.00001
      @log_zero = log_zero
    end
    def << mspec
      mspec.map {|msp| msp.map { |m|  m > 0 ? Math::log(m) : @log_zero}}
    end
  end
end
