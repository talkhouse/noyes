module TestIncremental
  DD = 'data/noyes'
  def setup
    @nfilt = 32
    @min_freq = 200
    @max_freq = 3700
    @nfft = 256
    @freq = 8000
    @shift = 80
    @frame_size = 205
    
    packed = open("#{DD}/raw.dat", 'rb').read
    @pcm = packed.unpack('n*').map {|x| to_signed_short x}
    @preemphasizer = Preemphasizer.new 0.97
    @segmenter = Segmenter.new @frame_size, @shift
    @hamming_windower = HammingWindow.new @frame_size
    @power_spectrum_filter = PowerSpectrumFilter.new @nfft
    @mel_filter = MelFilter.new @freq, @nfft, @nfilt, @min_freq, @max_freq
    @compressor = LogCompressor.new
    @discrete_cosine_transform = DCT.new 13, @nfilt
    @live_cmn = LiveCMN.new
    @ddf = DoubleDeltaFilter.new
  end

  def test_preemphasis
    pre = []
    @pcm.each_slice 20 do |pcm|
        pre += @preemphasizer << pcm
    end
    ex_pre = open("#{DD}/pre.dat", 'rb').read.unpack 'g*'
    assert_m ex_pre, pre, 2
  end

  def test_segmentation
    variation = [@frame_size - 1, @frame_size, @frame_size + 1]
    segmentations = variation.map do |size|
      @pcm.each_slice size do |pcm|
          seg = @segmenter << pcm
      end
    end
    segmentations.each_cons 2 do |a, b|
        assert_equal a, b
    end
  end

  def test_incremental_front_end
    # This test fails on windows because of accumulated precision errors.
    # It's not clear that it makes sense to prevent them.  Maybe.
    unless Config::CONFIG['host_os'] =~ /mswin|mingw/
      dd = []
      @pcm.each_slice 15 do |pcm|
          pre = @preemphasizer << pcm
          seg = @segmenter << pre
          next unless seg
          ham = @hamming_windower << seg
          pow = @power_spectrum_filter << ham
          mel = @mel_filter << pow
          log_mel = @compressor << mel
          dct = @discrete_cosine_transform << log_mel
          cmn = @live_cmn << dct
          dd += @ddf << cmn
      end
      dd += @ddf.final_estimate
      ex_dd = open("#{DD}/dd.dat", 'rb').read.unpack 'g*'
      dd_flat = dd.flatten
      assert_m ex_dd[0,5616], dd_flat[0, 5616], 4
    end
  end
end
