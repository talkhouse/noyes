require 'test/unit'

module Test::Unit::Assertions
  # Assert significance: Much of the time I expect minor difference due to loss
  # of precision.  Rarely do I expect absolute differences.  Unfortunately,
  # assert_in_delta takes absolute differences.  This function takes an integer
  # value for the number of significant digits.
  def assert_sig e, r, sig, row=nil, col=nil
    # convert to string with length equal to the number of significant digits.
    # Decimal and sign are discarded of course.
    s1 = ("%f" % e).gsub(/[.-]/ ,'')[0, sig] 
    s2 = ("%f" % r).gsub(/[.-]/ ,'')[0, sig]
    if row
      assert s1 == s2, "[#{row}, #{col}] #{e} and #{r} not within #{sig}"
    else
      assert s1 == s2, "#{e} and #{r} not within #{sig}"
    end
  end
   
  def assert_m e, r, sig_digits, row=0
    if e.respond_to? :each and r.respond_to? :each
      assert_equal e.size, r.size, 'Matrices do not have the same number of elements' 
      if e.size == 0
        assert_true
      elsif !e.first.respond_to? :each and !r.first.respond_to? :each
        e.size.times do |i|
          assert_sig e[i], r[i], sig_digits, row, i
        end
      elsif e.first.respond_to? :each and !r.first.respond_to? :each
        fail "expected a matrix, got a vector" 
      elsif !e.first.respond_to? :each and r.first.respond_to? :each
        fail "expected a vector, got a matrix" 
      else
        for i in 0...e.size
          row += 1
          assert_m e[i], r[i], sig_digits, row
        end
      end
    else
      fail 'One of these is neither a matrix nor a vector'
    end
  end
end
