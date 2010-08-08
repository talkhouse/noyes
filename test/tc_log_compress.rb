module TestLogCompress
  def test_log_compress
    y = [[1,2,3],[4,5,6]]
    compressor = LogCompressor.new
    x = compressor << y
    z = [[0.0, 0.69314718, 1.0986122], [1.3862943, 1.6094379, 1.79175946]]
    assert_m z, x, 5
  end
end
