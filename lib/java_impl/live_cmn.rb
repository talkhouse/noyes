require 'java_filter'

module Noyes
  class LiveCMN
    include JavaFilter
    def initialize dimensions=13, mean=45.0, window_size=100, shift=160
      @filter = Java::talkhouse.LiveCMN.new 13, 45.0, 100, 160
    end
  end
end 
