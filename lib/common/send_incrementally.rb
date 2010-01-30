require 'signal'
include Signal

TMAGIC = '1.0 talkhouse'
TSTART = [0].pack('N')
TAUDIO = [1].pack('N')
TEND = [2].pack('N')
TDONE = [3].pack('N')
TCEPSTRA = [4].pack('N')

# Use sox to convert a file of almost any common type int pcm.
def file2pcm file
  raw = `sox #{file} -s -B -r 8k -b 16 -t raw -` 
  length = 16 # bits
  max = 2**length-1
  mid = 2**(length-1)
  to_signed = proc {|n| (n>=mid) ? -((n ^ max) + 1) : n}
  unpacked = raw.unpack 'n*'
  unpacked.map{|d| to_signed[d].to_f}
end

# Takes a file and two IO-like objects.
def send_incremental_features file, to_server, from_server
  nfilt = 32
  min_freq = 200
  max_freq = 3700
  nfft = 256
  freq = 8000
  shift = 80
  frame_size = 205
  preemphasizer = Preemphasizer.new 0.97
  segmenter = Segmenter.new frame_size, shift
  hamming_windower = HammingWindow.new frame_size
  power_spectrum_filter = PowerSpectrumFilter.new nfft
  mel_filter = MelFilter.new freq, nfft, nfilt, min_freq, max_freq
  discrete_cosine_transform = DCT.new 13, nfilt
  live_cmn = LiveCMN.new
  pcm = file2pcm file
  to_server.write TMAGIC
  to_server.write TSTART
  pcm.each_slice 1230 do |data|
    data >>= preemphasizer
    data >>= segmenter
    next unless data
    data >>= hamming_windower
    data >>= power_spectrum_filter
    data >>= mel_filter
    data = log_compress data
    data >>= discrete_cosine_transform
    data >>= live_cmn
    to_server.write TCEPSTRA
    to_server.write [data.size].pack('N')
    print '.'
    data.each {|cmn| to_server.write cmn.pack('g*')} 
    to_server.flush
  end
  to_server.write TEND
  to_server.write TDONE
  to_server.flush
  from_server.read
end
