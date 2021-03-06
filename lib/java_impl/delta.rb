require 'java_impl/java_filter'

module NoyesJava
  class DoubleDeltaFilter
    include JavaFilter
    def initialize
      @filter = Java::talkhouse.DoubleDeltaFilter.new
    end
    def final_estimate
      x = @filter.final_estimate
      x.map{|a|a.to_a}
    end
  end
end
