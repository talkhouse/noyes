require 'java_filter'
module Noyes
  class LogCompressor
    include JavaFilter
    def initialize log_zero = -0.00001
      @filter = Java::talkhouse.LogCompressor.new log_zero
    end
  end
end
