require 'java_impl/java_filter'

module NoyesJava
  class MelFilter
    include JavaFilter
    def initialize srate, nfft, nfilt, lowerf, upperf
      @filter = Java::talkhouse.MelFilter.new srate, nfft, nfilt, lowerf, upperf
    end
    def self.make_bank_parameters srate, nfft, nfilt, lowerf, upperf
      parameters = Java::talkhouse.MelFilter.make_bank_parameters srate, nfft,
                                                        nfilt, lowerf, upperf
      parameters.map {|array|array.to_a}
    end
    def self.make_filter left, center, right, init_freq, delta
      filters = Java::talkhouse.MelFilter.make_filter left, center, right,
                                                      init_freq, delta
      filters = filters.to_a
      indefilters = filters.shift
      [indefilters, filters]
    end
    def self.to_mel f
      x = Java::talkhouse.MelFilter.mel JavaFilter.ensure_jarray f
    end
    def self.to_linear mel
      Java::talkhouse.MelFilter.melinv JavaFilter.ensure_jarray mel
    end
  end
end
