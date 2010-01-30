include Java
module Signal
  class Segmenter
    def initialize win_size, win_shift
      @seg = Java::talkhouse.Segmenter.new win_size, win_shift
    end
    def << data
      array_res = @seg.apply data.to_java(:double)
      array_res.map {|a| a.to_a} if array_res
    end
  end
end
