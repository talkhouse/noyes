module TestLogCompress
  def test_log_compress
    y = [[1,2,3],[4,5,6]]
    compressor = LogCompressor.new
    x = compressor << y
    z = [[0.0, 0.69314718, 1.0986122], [1.3862943, 1.6094379, 1.79175946]]
    assert_m z, x, 5
  end
    
  def txest_log_compress
    seg = Segmenter.new 4, 512
    ham = HammingWindow.new 4
    power_spectrum_filter = PowerSpectrumFilter.new 512
    mel = MelFilter.new 16000, 2048, 40, 100, 6400
    compressor = LogCompressor.new
    data = (1..512).to_a
    segments = seg << data
    h = ham << segments
    p = power_spectrum_filter << h
    m = mel << p
    result = compressor << m
    expected = [[4.57766297803212, 4.72888460735928, 4.70748667037798,
      4.67961420120655, 4.72029175743122, 4.74614066883429, 4.75840197980759,
      4.7538393591332, 4.73388283126175, 4.64365702126193, 4.59305165625985,
      4.56829355399024, 4.4668191557196, 4.33677461920032, 4.180399954196,
      4.02134110668053, 3.78638737432661, 3.49542185728724, 3.18974002858545,
      2.79474228521, 2.33032584641896, 1.83184354059364, 0.663204014231244, -1.0e-05,
      -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05,
      -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05, -1.0e-05,
      -1.0e-05]]
    result.zip(expected) {|a,b| a.to_a.zip(b) {|x,y| assert_in_delta x,y,0.000001}}
  end
end
