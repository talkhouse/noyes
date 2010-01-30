class Array
  # The magic that enables the filter operator.
  def >> other
    other << self
  end
end
