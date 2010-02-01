module Noyes
  # Takes an m x n array and makes an m x 3 x n array.  The original inner
  # array is duplicated followed by its delta and it's double delta.
  class DoubleDeltaFilter
    def initialize
      @previous = nil
    end
    def << cepstra
      @previous = [cepstra.first] * 3 unless @previous
      buf = @previous + cepstra
      result = []
      for i in 3...(buf.size-3)
         delta = Array.new buf[i].size
         delta.size.times do |k|
           delta[k] = buf[i+2][k] - buf[i-2][k]
         end
         double_delta = Array.new buf[i].size
         double_delta.size.times do |k|
           double_delta[k] = buf[i+3][k] - buf[i-1][k] - buf[i+1][k] + buf[i-3][k]
         end
         result << [buf[i], delta, double_delta]
      end
      @previous = buf[-6..-1]
      result
    end
    # If there is no more data we can estimate a couple more frames by copying
    # the final frame 3 times.  Probably this is rarely necessary.
    def final_estimate
      return [] unless @previous
      cepstra = [@previous.last] * 3
      self.<< cepstra
    end
  end
end
