module Signal
  class Filter
    def initialize weights
      @weights = weights
    end
    def << data
      data.zip(@weights).map {|d, h| d*h}
    end
  end
end
