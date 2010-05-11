#require 'noyes'
require 'tu_extensions'
require 'c_impl/noyes_c'
require 'common'
require 'tc_preemphasis'
require 'tc_segment'
require 'tc_hamming_window'
require 'tc_power_spec'
require 'tc_mel_filter'
require 'tc_log_compress'
require 'tc_dct'
require 'tc_live_cmn'

module NoyesC
  class Preemphasizer
    include NoyesFilterDSL
  end
  class Segmenter
    include NoyesFilterDSL
  end
end

#    ham = NoyesC::HammingWindow.new 10
#    res = ham << [[1,1,1,1,1,1,1,1,1,1]]
#    expected = [0.08, 0.18761955616527, 0.460121838273212,
#               0.77, 0.972258605561518, 0.972258605561518,
#               0.77, 0.460121838273212, 0.18761955616527, 0.08]
#p res
#seg = NoyesC::Segmenter.new 4, 2
#ham = NoyesC::HammingWindow.new 2
#
#data = (1..16).to_a
#data = seg << data
#p data
#data = ham << data
#p data
make_test 'NoyesC', 'Preemphasis'
make_test 'NoyesC', 'Segment'
make_test 'NoyesC', 'HammingWindow'
make_test 'NoyesC', 'PowerSpec'
make_test 'NoyesC', 'MelFilter'
make_test 'NoyesC', 'LogCompress'
make_test 'NoyesC', 'DCT'
make_test 'NoyesC', 'LiveCMN'
