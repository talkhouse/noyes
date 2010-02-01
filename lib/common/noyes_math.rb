module Math
  def dot_product l1, l2
    sum = 0
    for i in 0...l1.size
      sum += l1[i] * l2[i]
    end
    sum
  end
end

# Converts from unsigned to signed short.  Ruby, strangely enough, doesn't have
# network byte order short conversion for signed shorts.
def to_signed_short n
  length = 16 # bits
  max = 2**length-1
  mid = 2**(length-1)
  n>=mid ? -((n ^ max) + 1) : n
end
