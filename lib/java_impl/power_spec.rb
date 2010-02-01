module Noyes
  class PowerSpectrumFilter
    def initialize nfft
      @ps = Java::talkhouse.PowerSpec.new nfft
    end
    def << data
      @ps.apply(data.to_java Java::double[]).to_a
    end
  end
end
