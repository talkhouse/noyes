class Array
  # The magic that enables the filter operator.
  def >> other
    other << self
  end
end

# This portion is still highly experimental.  It allows filters to be combined
# in complicated ways using a syntax similar to Backus Naur Form.  
module NoyesFilterDSL
  def + other
    other_filters = other.kind_of?(SerialFilter) ? other.filters.clone : other
    SerialFilter.new [self, other].flatten
  end
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
