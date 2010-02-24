require 'common/noyes_math'

module Noyes
  # Mel filter takes an m x n matrix.  The inner array becomes equal to the
  # number of mel filter banks (nfilt).  The dimensionality of the outer array
  # remains unchanged.
  class MelFilter  
    include Math
    def initialize srate, nfft, nfilt, lowerf, upperf
      bank_params = MelFilter.make_bank_parameters srate, nfft, nfilt, lowerf, upperf
      @indices = []
      @weights = []
      bank_params.map do |params|
        ind, weights = MelFilter.make_filter *params
        @indices << ind
        @weights << weights
      end
    end
    def << power_spectra
      power_spectra.map do |spectrum|
        mel_bank = Array.new @indices.size
	@indices.size.times do |i|
	  initial_index, weights = @indices[i], @weights[i]
	  output = 0.0
	  weights.size.times do |j|
	    index = initial_index + j
	    output += spectrum[index] * weights[j] if index < spectrum.length 
	  end
	  mel_bank[i] = output
	end
        mel_bank
      end
    end
    def self.to_mel f
      return f.map {|linfreq| self.to_mel linfreq} if f.respond_to? :map
      2595.0 * Math.log10(1.0 + f/700.0)
    end
    def self.to_linear m
      return m.map {|melfreq| self.to_linear melfreq} if m.respond_to? :map
      700.0 * (10.0**(m/2595.0) - 1.0)
    end
    def self.determine_bin in_freq, step_freq
      step_freq * (in_freq/step_freq).round
    end
    def self.make_bank_parameters srate, nfft, nfilt, lowerf, upperf
      raise 'Number of FFT points is <= 0.' if nfft == 0
      raise 'Number of filters is <= 0.' if nfilt == 0
      srate = srate.to_f; lowerf = lowerf.to_f; upperf = upperf.to_f
      left_edge = Array.new nfilt
      right_edge = Array.new nfilt
      center_freq = Array.new nfilt
      melmax = self.to_mel upperf
      melmin = self.to_mel lowerf
      delta_freq_mel = (melmax - melmin) / (nfilt + 1.0)
      delta_freq = srate/nfft
      left_edge[0] = self.determine_bin lowerf, delta_freq
      next_edge_mel = melmin
      nfilt.times do |i|
        next_edge_mel += delta_freq_mel
        next_edge = self.to_linear next_edge_mel
        center_freq[i] = self.determine_bin next_edge, delta_freq
        right_edge[i-1] = center_freq[i] if i > 0   
        left_edge[i+1] = center_freq[i] if i < nfilt - 1 
      end

      next_edge_mel += delta_freq_mel
      next_edge = self.to_linear next_edge_mel
      right_edge[nfilt-1] = self.determine_bin next_edge, delta_freq
      fparams = Array.new nfilt
      nfilt.times do |i| 
        initial_freq_bin = self.determine_bin left_edge[i], delta_freq
        initial_freq_bin += delta_freq if initial_freq_bin < left_edge[i]
        fparams[i] = [left_edge[i], center_freq[i], right_edge[i], 
                    initial_freq_bin, delta_freq]
      end
      fparams
    end
    def self.make_filter left, center, right, init_freq, delta
      raise 'delta freq has zero value' if delta == 0
      if (right - left).round == 0 || (center - left).round == 0 ||
         (right - center).round == 0
        raise 'filter boundaries too close'
      end
 
      n_elements = ((right - left)/ delta + 1).round
      raise 'number of mel elements is zero' if n_elements == 0

      weights = Array.new n_elements    
      height = 1
      left_slope = height / (center - left)
      right_slope = height / (center - right)

      index_fw = 0
      init_freq.step right, delta do |current|
        if current < center
          weights[index_fw] = left_slope * (current - left)
        else
          weights[index_fw] = height + right_slope * (current - center) 
        end
        index_fw += 1
      end
      #weights.insert 0, (init_freq/delta).round
      [(init_freq/delta).round, weights]
    end
    def apply_weights init_index, weights, spectrum
      output = 0.0
      weights.size.times do |i|
        output += spectrum[i + init_index] * weights[i] 
      end
      output
    end
  end
end
