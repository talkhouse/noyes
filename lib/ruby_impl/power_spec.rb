require 'discrete_fourier_transform'
module Noyes
  class PowerSpectrumFilter
    include Noyes
    def initialize nfft
      @nfft = nfft
    end
    def << data
    	nuniqdftpts = @nfft/2 + 1
    	data.map do |datavec|
    		datavecfft = dft datavec, @nfft
    		Array.new(nuniqdftpts){|i| datavecfft[i].abs**2}
    	end
    end
  end
end
