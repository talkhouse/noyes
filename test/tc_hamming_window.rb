require 'test/unit'
require 'hamming_window'
require 'segment'

class TestHammingWindow < Test::Unit::TestCase
  include Math
  include Signal
  def test_unity_segment
    ham = HammingWindow.new 10
    res = ham << [[1,1,1,1,1,1,1,1,1,1]]
    expected = [0.08, 0.18761955616527, 0.460121838273212, 
               0.77, 0.972258605561518, 0.972258605561518, 
               0.77, 0.460121838273212, 0.18761955616527, 0.08]
    expected.zip(res[0]) {|x,y|  assert_in_delta x, y, 0.000000000001}
  end
  def formula_test size
    ham = HammingWindow.new size
    x = ham << [Array.new(size,1)]
    a = x[0]
    size.times do |i|
      assert_in_delta 0.54 - 0.46*cos(2*PI*i/(size-1)), a[i], 0.0000001
    end
  end
  def test_formulae
     formula_test 10
     formula_test 15
     formula_test 99
  end
  def odd_test size
    ham = HammingWindow.new size
    x = ham << [Array.new(size, 1)]
    a = x[0] 
    assert_in_delta 1, a[size/2], 0.0000000001
    assert_in_delta a[size/2 + 1], a[size/2 -1], 0.00000001
  end
  def test_odd_segments
    odd_test 3
    odd_test 5
    odd_test 7
    odd_test 9
    odd_test 1001
    odd_test 777
  end
end
