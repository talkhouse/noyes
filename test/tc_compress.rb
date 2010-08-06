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
  def test_golumb_encode
    gre = Noyes::GolombRiceEncoder.new 8
    code = gre.encode(1..9).to_s  # Long enough to unary portion of code.
    expected = '0001 0010 0011 0100 0101 0110 0111 10000 10001'.gsub(/ /,'')
    assert_equal expected, code
  end
  def test_unary_code
    gre = Noyes::GolombRiceEncoder.new 1
    assert_equal '111110', gre.encode([5]).to_s
  end
  def test_golomb_rice_integers
    gre = Noyes::GolombRiceEncoder.new
    grd = Noyes::GolombRiceDecoder.new
    data = (0..100).to_a
    encoded = gre.encode data
    decoded = grd.decode encoded
    assert_equal data, decoded
  end
  def test_compression_ratio
    gre = Noyes::GolombRiceEncoder.new 8
    data = (1..9).to_a
    code = gre.encode(data).to_s  # Long enough to unary portion of code.
    assert code.size / (data.size * 32) < 15
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
  def xtest_bit_array
    ba = Noyes::BitArray.new
    50.times {|i| ba.push i % 2}
    assert_equal '01' * 25, ba.to_s

    ba = Noyes::BitArray.new
    50.times {|i| ba.push(i + 1) % 2}
    assert_equal '10' * 25, ba.to_s

    ba = Noyes::BitArray.new
    4.times {ba.push 1}
    ba.push 0
    3.times {ba.shift}
    assert_equal 1, ba[0]
    assert_equal 0, ba[1]
  end
  def test_float_compressor
    segmenter = Noyes::Segmenter.new(20,20)
    compressor = Noyes::NullCompressor.new
    decompressor = Noyes::NullDecompressor.new
    cmn = segmenter << IO.read("data/noyes/cmn.dat").unpack('g*')

    compressed = compressor << cmn
    uncompressed = decompressor << cmn
    assert_equal cmn, uncompressed
  end
end
