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
require 'tc_end_of_utterance'
require 'tc_queue'

module NoyesC
  class Preemphasizer
    include NoyesFilterDSL
  end
  class Segmenter
    include NoyesFilterDSL
  end
end

make_test 'NoyesC', 'Preemphasis'
make_test 'NoyesC', 'Segment'
make_test 'NoyesC', 'HammingWindow'
make_test 'NoyesC', 'PowerSpec'
make_test 'NoyesC', 'MelFilter'
make_test 'NoyesC', 'LogCompress'
make_test 'NoyesC', 'DCT'
make_test 'NoyesC', 'LiveCMN'
make_test 'NoyesC', 'EndOfUtterance'
make_test 'NoyesC', 'Queue'
