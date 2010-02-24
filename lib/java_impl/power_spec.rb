require 'java_impl/java_filter'

module NoyesJava
  class PowerSpectrumFilter
    include JavaFilter
    def initialize nfft
      @filter = Java::talkhouse.PowerSpec.new nfft
    end
  end
end
