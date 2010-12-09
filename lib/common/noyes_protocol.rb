TMAGIC = '1.0 talkhouse'

# The following constants are packed as 4 byte big-endian integers.
TSTART = [0].pack('N')
TPCM = [1].pack('N')
TEND = [2].pack('N')
TBYE = [3].pack('N')
TCEPSTRA = [4].pack('N')
TA16_16 = [5].pack('N')
TA16_44 = [6].pack('N')
