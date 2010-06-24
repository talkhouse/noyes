class Array
  # Run this array through a filter or anything that implements the '<<'
  # operator.  Returns whatever the filter returns.
  def >> filter
    filter << self
  end
end

# This portion is still highly experimental.  It allows filters to be combined
# in complicated ways using a syntax similar to Backus Naur Form.  
module NoyesFilterDSL
  # Combines two filters into a single serial filter.  That is A + B
  # results in a filter S such that filtering through S is the identical
  # to filtering through A and then B.
  def + other
    other_filters = other.kind_of?(SerialFilter) ? other.filters.clone : other
    SerialFilter.new [self, other].flatten
  end

  # Combines two filters into a single parallel filter.  That is A | B creates
  # a new filter P such that filtering through P is identical to filtering row
  # 0 of an array through filter A and row 1 of an array through filter B.
  # Typically P would be used with an array of arrays.  This filter can be used
  # with more than two filters.
  def | other
     other_filters = other.kind_of?(ParallelFilter) ? other.filtes.clone : other
     ParallelFilter.new [self, other].flatten
  end
end

module Noyes
  class DCT
    include NoyesFilterDSL
  end
  class DoubleDeltaFilter
    include NoyesFilterDSL
  end
  class Filter
    include NoyesFilterDSL
  end
  class HammingWindow
    include NoyesFilterDSL
  end
  class LiveCMN
    include NoyesFilterDSL
  end
  class LogCompressor
    include NoyesFilterDSL
  end
  class MelFilter
    include NoyesFilterDSL
  end
  class PowerSpectrumFilter
    include NoyesFilterDSL
  end
  class Preemphasizer
    include NoyesFilterDSL
  end
  class Segmenter
    include NoyesFilterDSL
  end
end
