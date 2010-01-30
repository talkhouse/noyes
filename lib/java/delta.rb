module Signal
  class DoubleDeltaFilter
    def initialize
      @jfilt = Java::talkhouse.DoubleDeltaFilter.new
    end
    def << cepstra
      x = @jfilt.apply cepstra.to_java Java::double[]
      x.map{|a|a.to_a}
    end
    def final_estimate
      x = @jfilt.final_estimate
      x.map{|a|a.to_a}
    end
  end
end
