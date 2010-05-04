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

make_test 'NoyesC', 'Preemphasis'
