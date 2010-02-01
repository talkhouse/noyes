def log_compress mspec
  mspec.map {|msp| msp.map { |m|  m > 0 ? log(m) : -0.00001}}
end
