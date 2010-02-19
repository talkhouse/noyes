module NoyesFilterDSL
  class SerialFilter
    attr_reader :filters
    def initialize filters = []
      @filters = filters.kind_of?(Array) ? filters : [filters]
    end
    def << data
      @filters.each {|f| data >>= f}
      data
    end
    def & other
      raise "Parameter does not respond to <<." unless other.respond_to? :<<
      if other.kind_of? SerialFilter
        return SerialFilter.new(@filters.clone + other.filters.clone)
      end
      SerialFilter.new((@filters + [other]).flatten)
    end
    def | other
      raise "Parameter does not respond to <<." unless other.respond_to? :<<
      other_filters = if other.kind_of? Array
        SerialFilter.new other 
      elsif other.kind_of? ParallelFilter
        other_filters = other.filters
      else
        other
      end
      ParallelFilter.new([SerialFilter.new(filters), other_filters])
    end
  end
end
