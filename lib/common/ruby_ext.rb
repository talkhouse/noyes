module Math
  def self.max a, b
    a > b ? a : b
  end
  def self.min a, b
    a < b ? a : b
  end
end
# I don't really undestand why Ruby 1.9 needs this.  It seems that Math gets
# redefine to CMath at some point.  So calling Math.max will fail in 1.9 unless
# I put these functions in CMath too.
module CMath
  def self.max a, b
    a > b ? a : b
  end
  def self.min a, b
    a < b ? a : b
  end
end
