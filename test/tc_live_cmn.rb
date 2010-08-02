require 'rbconfig'
module TestLiveCMN
  unless Config::CONFIG['host_os'] =~ /mswin|mingw/
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
  end
end
