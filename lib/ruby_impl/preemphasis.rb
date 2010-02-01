module Noyes
  # A simple high pass filter.  It takes an array of size n and returns an
  # array of size n.
  class Preemphasizer
    include Math
    def initialize factor=0.97
      @factor = factor
      @prior = 0
    end

    def << data
      prior = @prior
      @prior = data.last 
      data.map do |x|
         y = x - @factor * prior
         prior = x
         y
      end
    end
  end
end 
