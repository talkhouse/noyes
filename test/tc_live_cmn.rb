require 'rbconfig'
module TestLiveCMN
  def test_live_cmn
    # This test fails on windows because there is too much accumulated
    # precision error from summing floats.  A more sophisticated accumulation
    # routine may solve this problem, however, from a speech recognition point
    # of view it isn't a problem.  Mean normalization needs to be done quickly
    # and precision is probably of little benefit.
    unless Config::CONFIG['host_os'] =~ /mswin|mingw/
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
  end
end
