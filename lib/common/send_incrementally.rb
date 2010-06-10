require 'noyes'
require 'common/file2pcm'

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
# sent TBYE      # session is finished

# Use sox to convert a file of almost any common type int pcm.
# Not sure this works for anything beside 16 bits.
# Takes a file and two IO-like objects.
def send_incremental_features file, to_server, from_server, bits, freq
  stats = {}
  nfilt = 32
  min_freq = 200
  max_freq = 3700
  freq_adjustment = freq.to_i/8000
  nfft = 256 * freq_adjustment
  shift = 80 * freq_adjustment
  frame_size = 205 * freq_adjustment
  preemphasizer = Preemphasizer.new 0.97
  segmenter = Segmenter.new frame_size, shift
  hamming_windower = HammingWindow.new frame_size
  power_spectrum_filter = PowerSpectrumFilter.new nfft
  mel_filter = MelFilter.new freq, nfft, nfilt, min_freq, max_freq
  compressor = LogCompressor.new
  discrete_cosine_transform = DCT.new 13, nfilt
  live_cmn = LiveCMN.new
  pcm = file2pcm file, bits, freq
  stats[:audio_length] = pcm.size/freq.to_f
  to_server.write TMAGIC
  to_server.write TSTART
  stats[:process_time] = 0
  pcm.each_slice 1230 do |data|
    process_time_start = Time.new
    data >>= preemphasizer
    data >>= segmenter
    next unless data
    data >>= hamming_windower
    data >>= power_spectrum_filter
    data >>= mel_filter
    data >>= compressor
    data >>= discrete_cosine_transform
    data >>= live_cmn
    stats[:process_time] += Time.new - process_time_start
    to_server.write TCEPSTRA
    to_server.write [data.size].pack('N')
    print '.'
    data.each {|cmn| to_server.write cmn.pack('g*')} 
    to_server.flush
  end
  to_server.write TEND
  to_server.write TBYE
  to_server.flush
  latency_start = Time.new
  stats[:transcript] = from_server.read
  stats[:latency] = Time.new - latency_start
  return stats
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
  to_server.write TBYE
  to_server.flush
  from_server.read
end
