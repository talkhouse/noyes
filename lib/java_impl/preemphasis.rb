module NoyesJava
  class Preemphasizer
    include Math
    def initialize factor=0.97
      @filter = Java::talkhouse.Preemphasizer.new factor
    end
    def << data
      @filter.apply(data.to_java(:double)).to_a
    end
  end
end 
