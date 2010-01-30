require 'complex'
module Signal
  def dft data, size
    data = data.to_java :double
    x = Java::talkhouse::DiscreteFourierTransform.apply data, size
    x[0].zip(x[1]).map {|r, i| Complex(r,i)}
  end
end 
