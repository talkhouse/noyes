require 'test/unit'
require 'preemphasis'
class TestPreemphasis < Test::Unit::TestCase
  include Noyes
  def test_preemphasizer
    data = [1.0, 2.0, 3.0, 4.0]
    expected = [1.0, 1.03, 1.06, 1.09]
    preemphasizer = Preemphasizer.new 0.97
    res = preemphasizer << data
    expected.zip(res).each do |expected, actual|
      assert_in_delta expected, actual, 0.0001
    end
  end
  def test_split_data
    data = [1.0, 2.0, 3.0, 4.0]
    expected = [1.0, 1.03, 1.06, 1.09]
    preemphasizer = Preemphasizer.new 0.97
    res1 = preemphasizer << data[0,2]
    res2 = preemphasizer << data[2,4]
    res = res1 + res2
    expected.zip(res).each do |expected, actual|
      assert_in_delta expected, actual, 0.0001
    end
  end
end
