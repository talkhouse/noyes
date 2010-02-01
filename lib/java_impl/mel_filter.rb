module Noyes
  class MelFilter
    def initialize srate, nfft, nfilt, lowerf, upperf
      @jmf = Java::talkhouse.MelFilter.new srate, nfft, nfilt, lowerf, upperf
    end
    def << power_spectrum
      x = @jmf.apply power_spectrum.to_java Java::double[]
      x.map {|a|a.to_a}
    end
    def self.make_bank_parameters srate, nfft, nfilt, lowerf, upperf
      x = Java::talkhouse.MelFilter.make_bank_parameters srate, nfft, nfilt, lowerf, upperf
      x.map {|a|a.to_a}
    end
    def self.make_filter left, center, right, init_freq, delta
      x = Java::talkhouse.MelFilter.make_filter left, center, right, init_freq, delta
      x = x.to_a
      index = x.shift
      [index, x]
    end
    def self.to_mel f
      if f.respond_to? :each
        Java::talkhouse.MelFilter.mel f.to_java(Java::double[]).to_a
      else
        x = Java::talkhouse.MelFilter.mel f
      end
    end
    def self.to_linear mel
      if mel.respond_to? :each
        Java::talkhouse.MelFilter.melinv mel.to_java(Java::double[]).to_a
      else
        Java::talkhouse.MelFilter.melinv mel
      end
    end
  end
end
