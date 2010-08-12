# Complete implementation of an mfcc filter.
class Mfcc
  def inititialize nfilt = 40, min_freq = 133.33334, max_freq = 6855.4976,
                   nfft = 512, shift = 160, frame_size = 410

    @preemphasizer = Preemphasizer.new 0.97
    @segmenter = Segmenter.new frame_size, shift
    @hamming_windower = HammingWindow.new frame_size
    @power_spectrum_filter = PowerSpectrumFilter.new nfft
    @mel_filter = MelFilter.new freq, nfft, nfilt, min_freq, max_freq
    @compressor = LogCompressor.new
    @discrete_cosine_transform = DCT.new 13, nfilt
    @live_cmn = LiveCMN.new
  end

  def << data
    data >>= preemphasizer
    data >>= segmenter
    next unless data
    data >>= hamming_windower
    data >>= power_spectrum_filter
    data >>= mel_filter
    data >>= compressor
    data >>= discrete_cosine_transform
    live_cmn << data
  end
end
