module NoyesJava
  class BentCentMarker
    def initialize
      @bcm = Java::talkhouse.BentCentMarker.new
    end
    def logrms pcm
      @bcm.logRMS pcm.to_java(Java::double)
    end
    def << pcm
      @bcm.apply pcm.to_java(Java::double)
    end
  end
end
