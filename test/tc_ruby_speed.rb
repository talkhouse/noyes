require 'test/unit'
require 'hamming_window'

class TestRubySpeed < Test::Unit::TestCase
  def test_speed
    seg = Segmenter.new
    ham = HammingWindow.new 10
		data = (1..1000_000).to_a
		r = seg.do data, 10, 2
    start = Time.new
    r.each do |s|
      h = ham.do s
    end
      
    finish = Time.new
    total = finish - start
    assert total < 10, "Segmenter is too slow"
  end
end
