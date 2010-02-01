module Noyes
  class Preemphasizer
    include Math
    def initialize factor=0.97
      @pre = Java::talkhouse.Preemphasizer.new factor
    end
    # returns next prior and an array of processed data
    def << data
      result = @pre.apply data.to_java(:double)
      result.to_a
    end
  end
end 
