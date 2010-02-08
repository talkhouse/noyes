require 'java_filter'

module Noyes
  class PowerSpectrumFilter
    include JavaFilter
    def initialize nfft
      @filter = Java::talkhouse.PowerSpec.new nfft
    end
  end
end
