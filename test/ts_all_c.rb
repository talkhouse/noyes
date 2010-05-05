#require 'noyes'
require 'tu_extensions'
require 'c_impl/noyes_c'
require 'common'
require 'tc_preemphasis'
require 'tc_segment'

module NoyesC
  class Preemphasizer
    include NoyesFilterDSL
  end
  class Segmenter
    include NoyesFilterDSL
  end
end

x = NoyesC::Segmenter.new 4,2
p x
make_test 'NoyesC', 'Preemphasis'
#make_test 'NoyesC', 'Segment'
