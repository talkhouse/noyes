#!/usr/bin/env ruby
# vim: set filetype=ruby :
ROOT = File.dirname(File.dirname(__FILE__))
$: << "#{ROOT}/lib/ruby"
$: << "#{ROOT}/lib/common"

require 'signal'

if ARGV.size != 1 || ARGV[0] == '-h'
  puts "Usage: noyes_dump44k <file>"  
  exit 1
end

FILE = ARGV[0]
DIR = File.dirname FILE

include Signal
nfilt = 40
min_freq = 130
max_freq = 6800
nfft = 2048
freq = 44100
shift = 441
frame_size = 1130

preemphasizer = Preemphasizer.new 0.97
segmenter = Segmenter.new frame_size, shift
hamming_windower = HammingWindow.new frame_size
power_spectrum_filter = PowerSpectrumFilter.new nfft
mel_filter = MelFilter.new freq, nfft, nfilt, min_freq, max_freq
discrete_cosine_transform = DCT.new 13, nfilt
live_cmn = LiveCMN.new
ddf = DoubleDeltaFilter.new

raw = `sox #{FILE} -s -B -r 8k -b 16 -t raw -` 
open('raw.dat', 'wb') {|f| f.write raw}
pcm = raw.unpack 'n*'
pcm = pcm.map{|d| to_signed_short(d).to_f}
pre = preemphasizer << pcm
open("#{DIR}/pre.dat", 'w') {|f| f.write pre.flatten.pack 'g*' }
seg = segmenter << (pre + Array.new(frame_size - pre.size % frame_size, 0.0))
open("#{DIR}/seg.dat", 'w') {|f| f.write seg.flatten.pack 'g*'}
ham = hamming_windower << seg
open("#{DIR}/ham.dat", 'w') {|f| f.write ham.flatten.pack 'g*'}
pow = power_spectrum_filter << ham
open("#{DIR}/pow.dat", 'w') {|f| f.write pow.flatten.pack 'g*'}
mel = mel_filter << pow
open("#{DIR}/mel.dat", 'w') {|f| f.write mel.flatten.pack 'g*'}
log = log_compress mel
open("#{DIR}/log_mel.dat", 'w') {|f| f.write log.flatten.pack 'g*'}
dct = discrete_cosine_transform << log
open("#{DIR}/dct.dat", 'w') {|f| f.write dct.flatten.pack 'g*'}
cmn = live_cmn << dct
open("#{DIR}/cmn.dat", 'w') {|f| f.write cmn.flatten.pack 'g*'}
dd = ddf << cmn
dd += ddf.final_estimate
open("#{DIR}/dd.dat", 'w') {|f| f.write dd.flatten.pack 'g*'}


