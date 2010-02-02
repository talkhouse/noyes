module Noyes
  class ParallelFilter
    attr_reader :filters
    def initialize filters=[]
      @filters = filters.kind_of?(Array) ? filters : [filters]
    end
    def << data
      if data.size != @filters.size
        raise "data (%d) and filters (%d) must have same dimensions." %
          [data.size, @filters.size]
      end
      offset = -1
      @filters.map {|f| f << data[offset+=1]}
    end
    def + other
      raise "Parameter does not respond to <<." unless other.respond_to? :<<
      if other.kind_of?(ParallelFilter) && filters.size != other.filters.size
        raise "Parallel filters must have equal dimensions %d vs %d " %
          [filters.size, other.filters.size]
      end
      other_filters = if other.kind_of? SerialFilter
        other.filters.clone
      else
        other
      end
      SerialFilter.new([ParallelFilter.new(filters.clone),  other_filters].flatten)
    end
    def | other
      raise "Parameter does not respond to <<." unless other.respond_to? :<<
      if other.kind_of? ParallelFilter
        return ParallelFilter.new(@filters + other.filters)
      end
      ParallelFilter.new((@filters + other).flatten)
    end
  end
end
