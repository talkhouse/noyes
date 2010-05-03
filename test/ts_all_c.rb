require 'noyes'
require 'tu_extensions'
require 'c_impl/preemphasis'
require 'common'
require 'tc_preemphasis'

module NoyesC
  class Preemphasizer
    include NoyesFilterDSL
  end
end
x = NoyesC::Preemphasizer.new 3
x << [1,2,3,4]
p x.methods

make_test 'NoyesC', 'Preemphasis'
