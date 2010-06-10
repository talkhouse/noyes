require 'stringio'
require 'common/send_incrementally'
module TestIncrementalSend
  def test_send
    file = "data/noyes/noyes.flac"
    to_server = StringIO.new 'wb'
    from_server = StringIO.new 'dummy result'
    result = send_incremental_features file, to_server, from_server, 16, 8000
    raw_data = to_server.string
    assert_equal TMAGIC, raw_data.slice!(0,13)
    assert_equal TSTART, raw_data.slice!(0,4)
    id = raw_data.slice!(0,4)
    assert_equal TCEPSTRA, id
    cepstra = []
    while id == TCEPSTRA
      cep_count = 13 * raw_data.slice!(0,4).unpack('N')[0]
      cep_count.times do |i|
        cepstra << raw_data.slice!(0,4).unpack('g')[0]
      end
      id = raw_data.slice!(0,4)
    end
    assert_equal TEND, id
    assert_equal TBYE, raw_data.slice!(0,4)
    ex_cmn = IO.read("data/noyes/cmn.dat").unpack 'g*'
    assert_m ex_cmn[0, cepstra.size], cepstra, 5
  end
end
