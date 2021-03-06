require 'java_impl/java_filter'

module NoyesJava
  class HammingWindow
    include JavaFilter
    def initialize window_size
      @filter = Java::talkhouse.HammingWindow.new window_size
    end
  end
end
