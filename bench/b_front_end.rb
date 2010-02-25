require 'benchmark'
require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.banner = 'Usage: b_front_end.rb [options]'
  options[:implementation] = :ruby
  opt.on '-r', '--ruby', 'Use Ruby implementation' do
    options[:implementation] = :ruby
  end
  opt.on '-j', '--java', 'Use Java implementation' do
    options[:implementation] = :java
  end
  opt.on( '-h', '--help', 'Display this screen' ) do
    puts opt
    exit
  end
end.parse!

def run_benchmarks impl_mod
  Benchmark.bm do |b|
    packed = IO.read 'data/noyes/raw.dat'
    data = packed.unpack('n*').map {|x| to_signed_short(x).to_f}
    preemphasizer = impl_mod::Preemphasizer.new 0.97
    segmenter = impl_mod::Segmenter.new 1130, 441 
    hamming_windower = impl_mod::HammingWindow.new 1130
    power_spectrum_filter = impl_mod::PowerSpectrumFilter.new 2048
    mel_filter = impl_mod::MelFilter.new 44100, 2048, 40, 130, 6800
    compressor = impl_mod::LogCompressor.new
    discrete_cosine_transform = impl_mod::DCT.new 13, 40
    live_cmn = impl_mod::LiveCMN.new
    ddf = impl_mod::DoubleDeltaFilter.new
    
    b.report("#{impl_mod}::preemphasizer")             {data >>= preemphasizer}
    b.report("#{impl_mod}::segmenter")                 {data >>= segmenter}
    b.report("#{impl_mod}::hamming_windower")          {data >>= hamming_windower}
    b.report("#{impl_mod}::power_spectrum_filter")     {data >>= power_spectrum_filter}
    b.report("#{impl_mod}::mel_filter")                {data >>= mel_filter}
    b.report("#{impl_mod}::log")                       {data >>= compressor}
    b.report("#{impl_mod}::discrete_cosine_transform") {data >>= discrete_cosine_transform}
    b.report("#{impl_mod}::live_cmn")                  {data >>= live_cmn}
    b.report("#{impl_mod}::ddf")                       {data >>= ddf}
  end
end

case options[:implementation]
when :java
  require 'noyes_java'
  run_benchmarks NoyesJava
when :ruby
  require 'noyes'
  run_benchmarks Noyes
end
