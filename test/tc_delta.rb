require 'test/unit'
require 'test/tu_extensions.rb'
require 'signal'

class TestDelta < Test::Unit::TestCase
  include Signal
  # Velocity and change should always be zero for unchanging data.
  def test_flatline
    double_delta_filter = DoubleDeltaFilter.new
    row = Array.new 13, 22.233 # any number, doesn't matter.
    data = [row] * 10
    result = double_delta_filter << data
    result.each do |cepvec|
      cepvec[1].each {|delta|assert_equal 0, delta}
      cepvec[2].each {|double_delta|assert_equal 0, double_delta}
    end
    assert_equal 10, data.size
    assert_equal 7, result.size
  end
  def test_45_degrees
    double_delta_filter = DoubleDeltaFilter.new
    data = []
    row = Array.new(13) {|i| i}
    20.times do |i|
      data << row.map{|j| i}
    end
    result = double_delta_filter << data
    result[0][0].each {|cepstrum| assert_equal 0, cepstrum}
    result[0][1].each {|cepstrum| assert_equal 2, cepstrum}
    result[0][2].each {|cepstrum| assert_equal 2, cepstrum}
    result[1][0].each {|cepstrum| assert_equal 1, cepstrum}
    result[1][1].each {|cepstrum| assert_equal 3, cepstrum}
    result[1][2].each {|cepstrum| assert_equal 2, cepstrum}
    result[2][0].each {|cepstrum| assert_equal 2, cepstrum}
    result[2][1].each {|cepstrum| assert_equal 4, cepstrum}
    result[2][2].each {|cepstrum| assert_equal 1, cepstrum}
    for i in 3...result.size do
      result[i][0].each {|cepstrum| assert_equal i, cepstrum}
      result[i][1].each {|cepstrum| assert_equal 4, cepstrum}
      result[i][2].each {|cepstrum| assert_equal 0, cepstrum}
    end
    assert_equal 20, data.size
    assert_equal 17, result.size
  end
  def test_incremental
    double_delta_filter = DoubleDeltaFilter.new
    data = []
    row = Array.new(13) {|i| i}
    20.times do |i|
      data << row.map{|j| i}
    end
    result = double_delta_filter << data[0,10]
    result += double_delta_filter << data[10,10]
    expected = [[[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2], [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]], [[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], [[16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16], [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]]
    assert_m expected, result, 6
  end
  def test_incremental2
    double_delta_filter = DoubleDeltaFilter.new
    data = []
    row = Array.new(1) {|i| i}
    10.times do |i|
      data << row.map{|j| i.to_f}
    end
    result = double_delta_filter << data[0,5]
    result += double_delta_filter << data[5,5]
    dd2 = DoubleDeltaFilter.new
    expected = dd2 << data
    result
    assert_m expected, result, 8
  end
end
