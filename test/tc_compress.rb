require 'test/unit'
require 'noyes'


class TestCompress < Test::Unit::TestCase
  DD = 'data/noyes'
  def test_compressability
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
    compression = Compression.new
    ulaw = ULaw.new

    packed = IO.read("#{DD}/raw.dat")
    pcm = packed.unpack 'n*'
    pcm = pcm.map{|d| to_signed_short(d).to_f}
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
      old_data = data
      data >>= ulaw
      data.zip(old_data).each {|cmn| puts "#{cmn[0][0]} #{cmn[1][0]}"}
    end
  end
end
