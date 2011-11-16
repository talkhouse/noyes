require 'stringio'

# Convert audio file into an IO object with features.
def file2fstream file, format = FEAT8M16R
  to_server = StringIO.new 'wb'
  from_server = StringIO.new 'dummy result'
  result = send_incremental_features file, to_server, from_server, 16, format
  StringIO.new to_server.string
end

# Take a talkhouse feature stream and convert it into an array.
def stream2features stream
  observations = []
  raise "Unexpected magic number." if stream.read(TMAGIC.size) != TMAGIC
  raise "Expected TSTART."         if stream.read(4) != TSTART
  loop do
    case stream.read(4)
      when TPCM
      count = stream.read(4).unpack('N')[0]
      pcm = stream.read count
      pcm = pcm.unpack('g*')
      when TCEPSTRA
      count = stream.read(4).unpack('N')[0]
      cmn = Array.new(count) {stream.read(13*4).unpack('g*')}
      observations += cmn
      when TBYE
      break
      when TEND
      else
      end
   end
  delta_filter = Noyes::DoubleDeltaFilter.new
  observations >>= delta_filter
  observations.map {|a| a.flatten}
end

# Convenience function for converting almost any type of audio file to an mfcc
# feature array.
def file2features file, format = FEAT8M16R
  stream = file2fstream file, format
  stream2features stream
end
