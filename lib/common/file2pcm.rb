def file2pcm file, bits, freq
  raw = `sox #{file} -s -B -r #{freq} -b #{bits} -t raw -`
  length = bits.to_i # bits
  max = 2**length-1
  mid = 2**(length-1)
  to_signed = proc {|n| (n>=mid) ? -((n ^ max) + 1) : n}
  unpacked = raw.unpack 'n*'
  unpacked.map{|d| to_signed[d].to_f}
end
