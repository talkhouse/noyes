module TestMelFilter
  def test_to_mel
    1000.step 20000, 1000 do |linear_freq|
      mel_freq = MelFilter.to_mel linear_freq
      exp_mel_freq = 2595 * Math.log10(linear_freq.to_f/700.0 + 1)
      assert_sig exp_mel_freq, mel_freq,  6
    end
  end
  def test_to_linear
    1000.step 20000, 1000 do |mel_freq|
      linear_freq = MelFilter.to_linear mel_freq
      exp_linear_freq = 700 * (Math::E ** (mel_freq.to_f/1127.0) - 1)  
      assert_sig exp_linear_freq, linear_freq, 3
    end
  end
  def test_to_mel_and_back
    100.step 20000, 300 do |linear_freq|
      mel_freq = MelFilter.to_mel linear_freq
      linear_freq_again = MelFilter.to_linear mel_freq
      assert_sig linear_freq, linear_freq_again, 6
    end
  end
  def test_individual_filter_creation
     ind, filt = MelFilter.make_filter 129.19921875, 172.265625,
                     215.33203125, 129.19921875, 21.533203125
     exp_filt = [0.0, 0.5, 1.0, 0.5, 0.0]
     assert_m exp_filt, filt, 5
     assert_equal 6, ind
  end
  def test_many_individual_filter_creations
    lines = IO.readlines 'data/mel/mel_filter.dat'
    lines.shift
    0.step lines.size - 1, 2 do |i|
      input = lines[i].split.map{|x| x.to_f}
      make_filter_parameters = input
      ind, filts = MelFilter.make_filter *make_filter_parameters
      expected = lines[i+1].split.map{|x| x.to_f}
      exp_ind = expected.shift.round
      assert_m expected, filts, 5
      assert_equal ind, exp_ind
    end
  end
  def test_filter_bank_parameter_creation
    parameters = MelFilter.make_bank_parameters 44100, 2048, 40, 130, 6800
    lines = IO.readlines 'data/mel/mel_filter.dat'
    lines.shift
    0.step lines.size - 1, 2 do |i|
      input = lines[i].split.map{|x| x.to_f}
      make_filter_parameters = input
      expected = lines[i].split.map{|x| x.to_f}
      assert_m expected, parameters[i/2], 5
    end
  end
  def test_mel_filter
    # precision is much lower on windows for this test due to expected roundoff
    # error.
    precision = Config::CONFIG['host_os'] =~ /mswin|mingw/ ? 1 : 4
    f = open('data/watchtower/pow.dat', 'rb')
    flat_power = f.read.unpack 'g*'
    power = []
    0.step flat_power.size-1025, 1025 do |i|
      power << flat_power[i, 1025]
    end
    mel_filter = MelFilter.new 44100, 2048, 40, 130, 6800
    mel = mel_filter << power
    ex_mel = IO.read('data/watchtower/mel.dat').unpack 'g*'
    mel_flat = mel.flatten
    assert_m ex_mel, mel_flat, precision
  end
end
