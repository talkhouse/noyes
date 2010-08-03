module TestFrontEnd8k
  DD = 'data/noyes'
  def test_noyes
    nfilt = 32
    min_freq = 200
    max_freq = 3700
    nfft = 256
    freq = 8000
    shift = 80
    frame_size = 205
    
    preemphasizer = Preemphasizer.new 0.97

    pcm = open("#{DD}/raw.dat", 'rb').read.unpack 'n*'
    pcm = pcm.map{|d| to_signed_short(d).to_f}

    #puts "pcm dimensions = #{pcm.size}"
    pre = preemphasizer << pcm
    #puts "pre dimensions = #{pre.size}"
    ex_pre = open("#{DD}/pre.dat", 'rb').read.unpack 'g*'
    assert_m ex_pre, pre, 2

    segmenter = Segmenter.new frame_size, shift
    hamming_windower = HammingWindow.new frame_size
    seg = segmenter << (pre + Array.new(frame_size - pre.size % frame_size, 0))
    #puts "segmenter dimensions #{seg.size} #{seg[0].size}"

    ham = hamming_windower << seg
    #puts "hamming dimensions #{ham.size} #{ham[0].size}"
    ham_flat = ham.flatten
    assert_equal ham_flat.size, seg.flatten.size
    ex_ham = open("#{DD}/ham.dat", 'rb').read.unpack 'g*'
    assert_m ex_ham, ham_flat, 2

    power_spectrum_filter = PowerSpectrumFilter.new nfft
    pow = power_spectrum_filter << ham
    ex_pow = open("#{DD}/pow.dat", 'rb').read.unpack 'g*'
    pow_flat = pow.flatten
    assert_m ex_pow, pow_flat, 2

    mel_filter = MelFilter.new freq, nfft, nfilt, min_freq, max_freq
    mel = mel_filter << pow
    ex_mel = open("#{DD}/mel.dat", 'rb').read.unpack 'g*'
    mel_flat = mel.flatten
    assert_m ex_mel, mel_flat, 2

    compressor = LogCompressor.new
    log_mel = compressor << mel

    discrete_cosine_transform = DCT.new 13, nfilt
    dct = discrete_cosine_transform << log_mel
    ex_dct = open("#{DD}/dct.dat", 'rb').read.unpack 'g*'
    dct_flat = dct.flatten
    assert_m ex_dct, dct_flat, 2
    
    live_cmn = LiveCMN.new
    cmn = live_cmn << dct
    #puts "cmn dimensions = #{cmn.size} x #{cmn[0].size}"
    ex_cmn = open("#{DD}/cmn.dat", 'rb').read.unpack 'g*'
    cmn_flat = cmn.flatten
    assert_m ex_cmn, cmn_flat, 2

    ddf = DoubleDeltaFilter.new
    dd = ddf << cmn
    dd += ddf.final_estimate
    #puts "dd dimensions = #{dd.size} x #{dd[0].size} x #{dd[0][0].size}"
    ex_dd = open("#{DD}/dd.dat", 'rb').read.unpack 'g*'
    dd_flat = dd.flatten
    assert_m ex_dd, dd_flat, 2
  end
end
