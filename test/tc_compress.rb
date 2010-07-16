require 'test/unit'
require 'noyes'


class TestCompress < Test::Unit::TestCase
  DD = 'data/noyes'
  def test_compressability
    compressor = Noyes::NullCompressor.new

    packed = IO.read("#{DD}/cmn.dat")
    cmn = packed.unpack 'n*'
    cmn = cmn.map{|d| to_signed_short(d).to_f}
    compressed = []
    cmn.each_slice 13 do |data|
      compressed << (compressor << data)
    end
    assert_m cmn, compressed.flatten, 5
  end
end
