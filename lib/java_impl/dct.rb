require 'java_filter'
module Noyes
  class DCT
    include JavaFilter
    def initialize order, ncol
      @filter = Java::talkhouse.DiscreteCosineTransform.new order, ncol
    end
    def melcos
      @filter.melcos.map {|a|a.to_a}
    end
  end
end
