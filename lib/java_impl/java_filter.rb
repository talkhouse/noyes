module Noyes
  module JavaFilter
    def << data
      java_matrix = @filter.apply data.to_java Java::double[]
      java_matrix.map {|java_array|java_array.to_a}
    end
  end
end
