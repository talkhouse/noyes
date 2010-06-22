# This is only for testing the c implementation of an array.  
module TestQueue
  def test_add
    x = ArrayList.new
    assert_equal 0, x.size
    50.times {|i| x.add i}
    assert_equal 50, x.size
    50.times {|i| assert_equal i, x.get(i)}
    50.times {|i| x.add i + 50}
    assert_equal 100, x.size
    100.times {|i| assert_equal i, x.get(i)}
  end
  def test_remove_front
    x = ArrayList.new
    100.times {|i| x.add i}
    x.remove 0, 1
    assert_equal 99, x.size
    99.times {|i| assert_equal i + 1, x.get(i)}

    49.times {x.remove 0, 1}
    assert_equal 50, x.size
    50.times {|i| assert_equal i + 50, x.get(i)}

    x.remove 0, 10
    40.times {|i| assert_equal i + 60, x.get(i)}

    x.remove 0, 11
    29.times {|i| assert_equal i + 71, x.get(i)}
  end
  def test_remove_end
    x = ArrayList.new
    100.times {|i| x.add i}
    x.remove 99, 100
    assert_equal 99, x.size
    99.times {|i| assert_equal i, x.get(i)}
    x.remove 90, 99 
    assert_equal 90, x.size
  end
  def test_remove_middle
    x = ArrayList.new
    100.times {|i| x.add i}
    x.remove 50, 60
    assert_equal 90, x.size
    50.times {|i| assert_equal i, x.get(i)}
    40.times {|i| assert_equal 60 + i, x.get(50 + i)}
  end
  def test_stress
    x = ArrayList.new
    100.times {|i| x.add i}
    10.times do
      10.times {|i| x.remove i, i+5}
      50.times {|i| x.add i}
    end
    assert_equal 100, x.size
  end
  def test_exception
    x = ArrayList.new
    assert_raise ArgumentError do 
      x.remove 10,20
    end
  end
end
