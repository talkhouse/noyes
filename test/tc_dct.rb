require 'yaml'

module TestDCT
  def test_dct
    dctin = YAML.load_file 'test/yml/testdct/dctin.yml'
    dct = DCT.new 13, dctin[0].size
    result = dct << dctin
    dctexp = YAML.load_file 'test/yml/testdct/dctexp.yml'
    assert_m dctexp, result, 6
  end
  def test_melcos
    dct = DCT.new 13, 40
    result = dct.melcos
    expected = YAML.load_file 'test/yml/testdct/melcos-13-40.yml'
    expected.zip(result) {|a,b| a.zip(b) {|x,y| assert_in_delta x,y,0.000001}}
  end 
end
