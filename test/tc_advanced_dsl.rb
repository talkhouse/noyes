require 'test/unit'
require 'noyes'

class IncrementFilter
  def << data
    data.map {|x| x+1}
  end
end

class DataDoublingFilter
  def << data
    [data.clone, data.clone]
  end
end

class TestAdvancedDsl < Test::Unit::TestCase
  include Noyes
  include NoyesFilterDSL
  def test_error_with_unfilter_like_object
    # A filter is anything that produces a result via the << operator.
    assert_raise(RuntimeError) {SerialFilter.new & 3.2}
    assert_raise(RuntimeError) {ParallelFilter.new & 3.2}
    assert_raise(RuntimeError) {SerialFilter.new | 3.2}
    assert_raise(RuntimeError) {ParallelFilter.new | 3.2}
  end
  def test_serial_processing
    sf = SerialFilter.new [IncrementFilter.new, IncrementFilter.new]
    data = [1,2,3,4]
    result = sf << data
    assert_equal data.map {|x| x + 2}, result    
  end
  def test_adding_serial_filters
    plus2 = SerialFilter.new [IncrementFilter.new, IncrementFilter.new]
    plus4 = plus2 & plus2
    data = [1,2,3,4]
    result = plus4 << data
    assert_equal data.map {|x| x + 4}, result    
    plus5 = plus4 & IncrementFilter.new
    result = plus5 << data
    assert_equal data.map {|x| x + 5}, result    
  end
  def test_adding_filter_arrays
    sf = SerialFilter.new [IncrementFilter.new]
    triple_sf = sf & [IncrementFilter.new, IncrementFilter.new]
    data = [1,2,3,4]
    result = triple_sf << data
    assert_equal data.map {|x| x + 3}, result    
  end
  def test_parallel_filtering
    pf = ParallelFilter.new [IncrementFilter.new, IncrementFilter.new]
    data = [[1,2,3,4],[2,3,4,5]]
    result = pf << data
    expected = data.map {|y| y.map {|x| x+1}}
    assert_equal expected, result
  end
  def test_combining_parallel_filters
    pf = ParallelFilter.new [IncrementFilter.new, IncrementFilter.new]
    triple_filter = pf | ParallelFilter.new(IncrementFilter.new)
    data = [[1,2,3,4],[],[3,4,5,6, 11]]
    result = triple_filter << data
    expected = data.map {|y| y.map {|x| x+1}}
    assert_equal expected, result
  end
  def test_summing_parallel_filters
    pf = ParallelFilter.new [IncrementFilter.new, IncrementFilter.new]
    triple_filter = pf | ParallelFilter.new(IncrementFilter.new)
    double_triple = triple_filter & triple_filter
    data = [[1,2,3,4],[],[3,4,5,6, 11]]
    result = double_triple << data
    expected = data.map {|y| y.map {|x| x+2}}
    assert_equal expected, result
  end
  def test_adding_serial_and_parallel
    pf = ParallelFilter.new [IncrementFilter.new, IncrementFilter.new]
    sf = SerialFilter.new(DataDoublingFilter.new)
    combined = sf & pf
    data = [1,2,3,4]
    result = combined << data
    expected = [data.map {|x| x+1}] * 2
    assert_equal expected, result
  end
  def test_serial_with_or
    sf = SerialFilter.new [IncrementFilter.new, IncrementFilter.new]
    parallel_sf = (sf | SerialFilter.new(IncrementFilter.new))
    data = [[1,2,3,4],[1,2,3,4]]
    result = parallel_sf << data
    assert [[3,4,5,6],[2,3,4,5]], result
  end
  def test_serial_with_or2
    sf = SerialFilter.new [IncrementFilter.new, IncrementFilter.new]
    parallel_sf = (sf | IncrementFilter.new)
    data = [[1,2,3,4],[1,2,3,4]]
    result = parallel_sf << data
    assert [[3,4,5,6],[2,3,4,5]], result
  end
  def test_preemphasizer_dsl
    # Notice I'm just using one preemphasizer.  That's because preemphasizers
    # don't save state.  I'd need to make two if I were to use a segmenter, for
    # example.
    pre = Preemphasizer.new
    parallel_pre = pre | pre
    large_array = (0..100).to_a
    small_array = (0..50).to_a
    data = [large_array, small_array]
    result = parallel_pre << data
    expected = [pre << large_array, pre << small_array]
    assert expected, result
  end
end
