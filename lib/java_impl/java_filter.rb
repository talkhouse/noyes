module Noyes
  module JavaFilter
    def << data
      java_matrix = @filter.apply data.to_java Java::double[]
      java_matrix.map {|java_array|java_array.to_a}
    end
    def self.ensure_jarray array
      if array.respond_to? :each
        array.to_java(Java::double[]).to_a
      else
	array
      end
    end
  end
end
