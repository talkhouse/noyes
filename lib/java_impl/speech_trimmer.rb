module NoyesJava
  class SpeechTrimmer
    def initialize
      @st = Java::talkhouse.SpeechTrimmer.new
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
      
