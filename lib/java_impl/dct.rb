module Noyes
  class DCT
    def initialize order, ncol
      @jdct = Java::talkhouse.DiscreteCosineTransform.new order, ncol
    end
    def << data
      x = @jdct.apply data.to_java Java::double[]
      x.map {|a|a.to_a}
    end
    def melcos
      @jdct.melcos.map {|a|a.to_a}
    end
  end
end
