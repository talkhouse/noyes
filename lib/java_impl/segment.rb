module Noyes
  class Segmenter
    def initialize win_size, win_shift
      @filter = Java::talkhouse.Segmenter.new win_size, win_shift
    end
    def << data
      java_matrix = @filter.apply data.to_java(:double)
      java_matrix.map {|java_array|java_array.to_a} if java_matrix
    end
  end
end
