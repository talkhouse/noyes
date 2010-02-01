require 'benchmark'
require 'noyes'
include Signal

Benchmark.bm do |b|
  packed = IO.read 'data/noyes/raw.dat'
  data = packed.unpack('n*').map {|x| to_signed_short(x).to_f}
  preemphasizer = Preemphasizer.new 0.97
  segmenter = Segmenter.new 1130, 441 
  hamming_windower = HammingWindow.new 1130
  power_spectrum_filter = PowerSpectrumFilter.new 2048
  mel_filter = MelFilter.new 44100, 2048, 40, 130, 6800
  discrete_cosine_transform = DCT.new 13, 40
  live_cmn = LiveCMN.new
  ddf = DoubleDeltaFilter.new
  
  b.report("preemphasizer")             {data >>= preemphasizer}
  b.report("segmenter")                 {data >>= segmenter}
  b.report("hamming_windower")          {data >>= hamming_windower}
  b.report("power_spectrum_filter")     {data >>= power_spectrum_filter}
  b.report("mel_filter")                {data >>= mel_filter}
  b.report("log")                       {data = log_compress data}
  b.report("discrete_cosine_transform") {data >>= discrete_cosine_transform}
  b.report("live_cmn")                  {data >>= live_cmn}
  b.report("ddf")                       {data >>= ddf}
end

