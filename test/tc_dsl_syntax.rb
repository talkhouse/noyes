require 'test/unit'
require 'noyes'

class TestFrontEnd < Test::Unit::TestCase
  include Signal
  def test_tiny
    data = (1..32).to_a
    segmenter = Segmenter.new 4, 2
    hamming_filter = HammingWindow.new 4
    power_spec_filter = PowerSpectrumFilter.new 8
    dct_filter = DCT.new 13, 40 
    data >>= segmenter
    data >>= hamming_filter
    data >>= power_spec_filter
    #data >>= dct_filter
  end
  def test_512
    data = (1..3536).to_a
    segmenter = Segmenter.new 4, 512
    hamming_filter = HammingWindow.new 4
    power_spec_filter = PowerSpectrumFilter.new 512
    mel_filter = MelFilter.new 16000, 2048, 40, 130, 6400
    dct_filter = DCT.new 13, 8 
    data >>= segmenter
    data >>= hamming_filter
    data >>= power_spec_filter
    data >>= dct_filter
    data >>= mel_filter
    #data = log_compress data
  end
  def test_shift_left_vs_shift_right_equals 
    seg = Segmenter.new 4, 512
    ham = HammingWindow.new 4
    pow = PowerSpectrumFilter.new 512
    mel = MelFilter.new 16000, 2048, 40, 100, 6400
    del = DoubleDeltaFilter.new 
    log = LogCompressor.new
    data = (1..(6*512)).to_a
    seg1 = seg << data
    ham1 = ham << seg1
    pow1 = pow << ham1
    mel1 = mel << pow1
    log1 = log << mel1
    del1 = del << log1
    seg2 = Segmenter.new 4, 512
    ham2 = HammingWindow.new 4
    pow2 = PowerSpectrumFilter.new 512
    mel2 = MelFilter.new 16000, 2048, 40, 100, 6400
    del2 = DoubleDeltaFilter.new 
    log2 = LogCompressor.new
    data = (1..(6*512)).to_a
    data >>= seg2
    assert seg1 == data
    data >>= ham2
    assert ham1 == data
    data >>= pow2
    assert pow1 == data
    data >>= mel2
    assert mel1 == data
    data = log2 << data
    assert log1 == data
    data >>= del2
    assert del1 == data
  end
end
