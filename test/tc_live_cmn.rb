module TestLiveCMN
  def test_live_cmn
    ex_dct = IO.read('data/noyes/dct.dat').unpack 'g*'
    dct =[]
    0.step ex_dct.size-13, 13 do |i|
      dct << ex_dct[i, 13]
    end 
    ex_cmn = IO.read('data/noyes/cmn.dat').unpack 'g*'

    live_cmn = LiveCMN.new
    cmn = live_cmn << dct
    cmn_flat = cmn.flatten
    assert_m ex_cmn, cmn_flat, 5
  end
end
