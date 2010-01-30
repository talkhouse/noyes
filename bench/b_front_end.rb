require 'benchmark'
require 'signal'
include Signal

Benchmark.bm do |x|
  data = IO.read('data/nlis/mic.raw').unpack 'G*'
  preemphasizer = Preemphasizer.new 0.97
  segmenter = Segmenter.new 1130, 441 
  hamming_windower = HammingWindow.new 1130
  power_spectrum_filter = PowerSpectrumFilter.new 2048
  mel_filter = MelFilter.new 44100, 2048, 40, 130, 6800
  discrete_cosine_transform = DCT.new 13, 40
  live_cmn = LiveCMN.new
  ddf = DoubleDeltaFilter.new
  
  x.report("preemphasizer")             {data >>= preemphasizer}
  x.report("segmenter")                 {data >>= segmenter}
  x.report("hamming_windower")          {data >>= hamming_windower}
  x.report("power_spectrum_filter")     {data >>= power_spectrum_filter}
  x.report("mel_filter")                {data >>= mel_filter}
  x.report("log")                       {data = log_compress data}
  x.report("discrete_cosine_transform") {data >>= discrete_cosine_transform}
  x.report("live_cmn")                  {data >>= live_cmn}
  x.report("ddf")                       {data >>= ddf}
end

