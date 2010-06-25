module NoyesJava
  class SpeechTrimmer
    def initialize frequency = 16000
      @st = Java::talkhouse.SpeechTrimmer.new frequency
    end
    def << pcm
      result = @st.apply(pcm.to_java(Java::double))
      result.to_a if result
    end
    def enqueue pcm
      @st.enqueue pcm.to_java(Java::double)
    end
    def dequeue
      speech = @st.dequeue
      speech.to_a if speech
    end
    def eos?
      @st.eos
    end
  end
end
      
