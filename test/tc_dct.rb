require 'yaml'

module TestDCT
  def test_dct
    dctin = YAML.load_file 'test/yml/dct/dctin.yml'
    dct = DCT.new 13, dctin[0].size
    result = dct << dctin
    dctexp = YAML.load_file 'test/yml/dct/dctexp.yml'
    assert_m dctexp, result, 6
  end
  def test_melcos
    dct = DCT.new 13, 40
    result = dct.melcos
    melcosexp = YAML.load_file 'test/yml/dct/melcos-13-40.yml'
    assert_m melcosexp, result, 6
  end 
end
