require 'noyes'
include Noyes

require 'noyes_protocol'
# The following flags are in network byte order (big endian) and are 4 bytes
# long. 
#
# The following is pseudo code for a transmitting audio
# send TMAGIC     # Magic number
# send TSTART     # Start of microphone
# while more audio
#   send TAUDIO_16b_8k
#   send length of array (in values, not bytes)
# end while
# sent TEND       # microphone is off
# sent TDONE      # session is finished

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
  compressor = LogCompressor.new
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
    data >>= compressor
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

def send_incremental_pcm file, to_server, from_server, depth, rate
  raw = `sox #{file} -s -B -r #{rate} -b #{depth} -t raw -` 
  to_server.write TMAGIC
  to_server.write TSTART
  chunk = raw.slice! 0, 1024
  while chunk.size > 0
    to_server.write TA16_16
    to_server.write [chunk.size/2].pack('N')
    to_server.write chunk
    print '.'
    to_server.flush
    chunk = raw.slice! 0, 1024
  end
  to_server.write TEND
  to_server.write TDONE
  to_server.flush
  from_server.read
end
