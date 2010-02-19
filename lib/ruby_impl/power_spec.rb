require 'discrete_fourier_transform'
module Noyes
  # The square of the DFT.  You must specify the number of ffts.  The power
  # spectrum returns an array of arrays where each inner array is of length
  # nfft/2 + 1.  The length of the outer array does not change.
  class PowerSpectrumFilter
    def initialize nfft
      @nfft = nfft
    end
    def << data
    	nuniqdftpts = @nfft/2 + 1
    	data.map do |datavec|
    		datavecfft = Noyes.dft datavec, @nfft
    		Array.new(nuniqdftpts){|i| datavecfft[i].abs**2}
    	end
    end
  end
end
