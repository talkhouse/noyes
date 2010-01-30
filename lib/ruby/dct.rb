require 'math_ext'

class DCT 
  include Math
  attr_accessor :melcos
  def initialize order, ncol
    @melcos = []
    order.times do |i|
      freq = PI * i.to_f / ncol
      ldct = Array.new ncol
      ncol.times do |j|
        ldct[j] = cos(freq * (j + 0.5)) / order # [1]
      end
      @melcos << ldct
    end
    @melcos
  end

  def << data
    data.map do |dvec|
      @melcos.map {|m| dot_product m, dvec}
    end
  end
end

# Notes:
# [1]  I'm not sure why I do this division by order.  Sphinx does it.  I wanted
# to have compatible output though I'm not sure I should care since I don't use
# sphinx anymore.  However, Sphinx does it continually during processing.  I
# build it into the filters so there is no cost.  
