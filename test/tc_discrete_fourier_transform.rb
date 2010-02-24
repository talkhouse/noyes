module TestDiscreteFourierTransform
  include Math
  def test_impulse
    data = [1] + Array.new(409, 0)
    res = dft data, 512 
    assert_equal 512, res.size
    data.zip(res) do |a, b| 
      assert_in_delta 1, b.real, 0.0000001
      assert_in_delta 0, b.imag, 0.0000001
    end
  end
  def test_double_impulse
    data = [1,1,0,0,0,0,0,0]
    res = dft data, data.size 
    expected_real = [2.0, 1.71, 1.0, 0.29, 0.0, 0.29, 1.0, 1.71]
    expected_imag = [0.0, 0.71, 1.0, 0.71, 0.0, -0.71, -1, -0.71]
    exp = Array.new(8) {|i| Complex(expected_real[i], expected_imag[i])}
    exp.zip(res) do |a, b|
      assert_in_delta a.real, b.real, 0.01
      assert_in_delta a.imag, b.imag, 0.01
    end
  end
  def test_five_impulses
    data = [1,1,1,1,1,0,0,0]
    res = dft data, data.size 
    expected_real = [5.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0]
    expected_imag = [0.0, 2.41, 0.0, 0.41, 0.0, -0.41, 0.0, -2.41]
    exp = Array.new(8) {|i| Complex(expected_real[i], expected_imag[i])}
    exp.zip(res) do |a, b|
      assert_in_delta a.real, b.real, 0.01
      assert_in_delta a.imag, b.imag, 0.01
    end
  end
  def test_cosine
    n = 16
    data = Array.new(n) {|i| cos((2*PI/n)* 1.5 * i)}
    res = dft data, data.size 
    imag = [0.00, -4.14,  5.69,  2.06,  1.20,  0.76,  0.46, 0.22,  
            0.00, -0.22, -0.46, -0.76, -1.20, -2.06, -5.69, 4.14] 
    magn = [1.00, 4.26, 5.77, 2.28, 1.56, 1.25, 1.10, 1.02, 
            1.00, 1.02, 1.10, 1.25, 1.56, 2.28, 5.77, 4.26] 
    data.size.times do |i|
      assert_in_delta 1, res[i].real, 0.01
      assert_in_delta imag[i], res[i].imag, 0.01
      assert_in_delta magn[i], res[i].abs, 0.01
    end
  end
end
