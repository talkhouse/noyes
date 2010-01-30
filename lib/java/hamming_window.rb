include Java
module Signal
  class HammingWindow
    def initialize window_size
      @hw = Java::talkhouse.HammingWindow.new window_size
    end

    def << data_segment
      data = data_segment.to_java Java::double[]
      @hw.apply(data).map{|a|a.to_a}
    end
  end
end
