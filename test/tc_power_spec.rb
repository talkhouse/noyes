module TestPowerSpec
    def test_power_spec
    data = (1..32).to_a
    seg = Segmenter.new 4, 2
    ham = HammingWindow.new 4
    power_spectrum_filter = PowerSpectrumFilter.new 8
    segments = seg << data
    hamming = ham << segments
    result = power_spectrum_filter << hamming
    expected = [[18.0625, 14.0308372357799, 6.4613, 1.60216276422015, 0.2809],
     [58.5225, 44.8625803488065, 19.7921, 4.33121965119355, 0.280900000000002],
     [122.1025, 93.3124623835625, 40.7405, 8.61973761643747, 0.280900000000002],
     [208.8025, 159.380483340048, 69.3065, 14.4677166599519, 0.280900000000002],
     [318.6225, 243.066643218263, 105.4901, 21.8751567817368, 0.280900000000003]]
    expected.zip(result) {|a,b| a.zip(b) {|x,y| assert_in_delta x,y,0.000001}}
    assert_equal expected[0].size, result[0].size, 'wrong number of points'
    end
end
