require 'test/unit'
require 'noyes'


class TestCompress < Test::Unit::TestCase
  DD = 'data/noyes'
  def setup
    packed = IO.read("#{DD}/cmn.dat")
    cmn = packed.unpack 'g*'
    @cmn = cmn.map{|d| to_signed_short(d).to_f}
  end
  def test_compressability
    compressor = Noyes::NullCompressor.new

    compressed = []
    @cmn.each_slice 13 do |data|
      compressed << (compressor << data)
    end
    assert_m @cmn, compressed.flatten, 5
  end

  def test_delta_encoder
    encoder = Noyes::DeltaEncoder.new
    decoder = Noyes::DeltaDecoder.new
    enc = encoder << @cmn
    dec = decoder << enc.flatten
    assert_m @cmn, dec.flatten, 5
  end
  def test_float_splitter
    fs = Noyes::FloatSplitter.new
    fa = Noyes::FloatAssembler.new
    gre = Noyes::GolombRiceEncoder.new
    splits = fs << @cmn
    reassembled = fa << splits
    assert_equal @cmn, reassembled
  end
  def test_interleave
    gre = Noyes::GolombRiceEncoder.new
    grd = Noyes::GolombRiceDecoder.new
    data = (-100..100).to_a
    interleaved = data.map {|x| gre.interleave x}
    deinterleaved = interleaved.map {|x| grd.deinterleave x}
    assert_equal data, deinterleaved
  end
  def test_golomb_rice_integers
    gre = Noyes::GolombRiceEncoder.new
    grd = Noyes::GolombRiceDecoder.new
    data = (0..100).to_a
    encoded = gre.encode data
    decoded = grd.decode encoded
    assert_equal data, decoded
  end
  def test_golomb_rice_floats
    fs = Noyes::FloatSplitter.new
    fa = Noyes::FloatAssembler.new
    gre = Noyes::GolombRiceEncoder.new
    grd = Noyes::GolombRiceDecoder.new
    splits = fs << @cmn
    coded = gre << splits
    uncoded = grd << coded
    reassembled = fa << uncoded
    assert_equal @cmn, reassembled
  end
  def test_bit_array
    ba = Noyes::BitArray.new
    50.times {|i| ba.push i % 2}
    assert_equal '01' * 25, ba.to_s

    ba = Noyes::BitArray.new
    50.times {|i| ba.push (i + 1) % 2}
    assert_equal '10' * 25, ba.to_s
  end
end
