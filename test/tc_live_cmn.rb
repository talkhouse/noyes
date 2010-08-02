module TestLiveCMN
  def test_live_cmn
    flat_dct = IO.read('data/noyes/dct.dat').unpack 'g*'
    dct =[]
    0.step flat_dct.size-13, 13 do |i|
      dct << flat_dct[i, 13]
    end 
    ex_cmn = IO.read('data/noyes/cmn.dat').unpack 'g*'

    live_cmn = LiveCMN.new
    cmn = live_cmn << dct
    cmn_flat = cmn.flatten
    assert_m ex_cmn, cmn_flat, 5
  end
  def test_dct_sum
    flat_dct = IO.read('data/noyes/dct.dat').unpack 'g*'
    dct =[]
    0.step flat_dct.size-13, 13 do |i|
      dct << flat_dct[i, 13]
    end 
    sums = Array.new 13,0
    dct.each do |mfc|
      sums.size.times {|i| sums[i] += mfc[i]}
    end


    expected = [10242.3816947937, -257.540581060573, 143.591144894774,
               -5.3736744876951, -13.8144978160853, -43.4587020128965, -16.08182763902,
               2.80991833936423, -58.3629225670011, 18.788794952794, 8.30175039544702,
               -63.9639747596812, -21.1389158053207]
    assert_m expected, sums, 5
  end
end
