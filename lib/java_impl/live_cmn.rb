module Noyes
  class LiveCMN
    def initialize dimensions=13, mean=45.0, window_size=100, shift=160
      @j_filt = Java::talkhouse.LiveCMN.new 13, 45.0, 100, 160
    end
    def << dct
      x = @j_filt.apply dct.to_java Java::double[]
      x.map{|a|a.to_a}
    end
  end
end 
