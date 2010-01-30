module Signal
  def log_compress mspec
    x = Java::talkhouse.LogCompress.apply mspec.to_java Java::double[]
    x.map{|a|a.to_a}
  end
end
