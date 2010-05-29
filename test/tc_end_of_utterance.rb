require 'yaml'
module TestEndOfUtterance
  DD = 'data/noyes'
  def test_eou_with_pcm
    eou_detector = EouEnergy.new
    packed = IO.read("#{DD}/raw.dat")
    pcm = packed.unpack 'n*'
    pcm = pcm.map{|d| to_signed_short(d).to_f}
    slices = []
    pcm.each_slice 80 do |frame|
      slices << (eou_detector << frame)
    end
    expected = YAML.load IO.read "#{DD}/is_speech.yml"
    assert_equal expected.size, slices.size, 'is_speech wrong length'
    assert_equal expected, slices, 'is_speech failed'
  end
end
