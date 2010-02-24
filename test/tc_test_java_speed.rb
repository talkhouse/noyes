module TestRubySpeed
  def test_hamming_window
    seg = Segmenter.new
    ham = HammingWindow.new 10
		data = (1..1000_000).to_a.to_java :double
		r = seg.do data, 10, 2
    start = Time.new
    r.each do |s|
      h = ham.do s
    end
      
    finish = Time.new
    total = finish - start
    assert total < 10, "Segmenter is too slow"
  end
  def test_segmenter
		data = (1..1000_000).to_a.to_java :double
    start = Time.new
		r = @seg.do data, 4, 2
    finish = Time.new
    total = finish - start
    assert total < 20, "Segmenter is too slow"
		expected = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7, 8], [7, 8, 9, 10]]
		expected.zip(r) {|a,b| a.to_a.zip(b) {|x,y| assert_in_delta x,y,0.000001}}
    expected = [999_997, 999_998, 999_999, 1000_000]
    expected.zip(r[-1]) {|a,b| assert_in_delta a, b, 0.000001}
  end
  def test_discrete_fourier_transform
    window_size = 410
    fft_points = 512
		data = (1..1_000).to_a.to_java :float
    seg = Segmenter.new
		segs = seg.do data, 410, 1
    start = Time.new
    segs.each do |s|
      dft s, fft_points 
      print '.'
    end
    finish = Time.new
    total = finish - start
    puts "dft speed is #{total}."
    #assert total < 5, "Discrete fourier transform is too slow"
  end
end

