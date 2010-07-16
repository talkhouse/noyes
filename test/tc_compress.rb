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
end
