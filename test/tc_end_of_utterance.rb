require 'yaml'
module TestEndOfUtterance
  DD = 'data/noyes'
  def setup
    packed = IO.read("#{DD}/raw.dat")
    @pcm = packed.unpack 'n*'
    @pcm = @pcm.map{|d| to_signed_short(d).to_f}
    @frames_per_10_millisecs = 80
  end
  def test_bent_cent_marker
    cent_marker = BentCentMarker.new
    slices = []
    @pcm.each_slice @frames_per_10_millisecs do |frame|
      slices << (cent_marker << frame)
    end
    expected = YAML.load IO.read "#{DD}/is_speech.yml"
    assert_equal expected.size, slices.size, 'is_speech wrong length'
    assert_equal expected, slices, 'is_speech failed'
  end
  def test_speech_trimmer
    # Parameters and data.
    leader = 5; trailer = 5
    segmenter = Segmenter.new 80, 80
    segments = segmenter << @pcm
    ecs = 50 # End centiseconds.
    scs = 20 # Start centiseconds.

    # Determine expected values.
    is_speech = YAML.load IO.read "#{DD}/is_speech.yml"
    speech_start = is_speech.index true
    false_count = 0
    speechlen = is_speech.drop(speech_start).each_with_index do |s, i|
      false_count = s ? 0 : false_count + 1
      break i - ecs if false_count == ecs
      i
    end
    expected_speech = segments[speech_start - leader,
                               speechlen + trailer + leader]

    # Get and test results from speech trimmer.
    trimmer = SpeechTrimmer.new
    speech = segments.inject [] do |memo, centisec|
      trimmer.enqueue centisec unless trimmer.eos?
      while x = trimmer.dequeue
        memo << x
      end
      break memo if trimmer.eos?
      memo
    end

    #open('spc.raw', 'wb') {|f| f.write speech.flatten.pack 'n*'}
    assert_m expected_speech, speech, 5
    assert_equal expected_speech, speech
  end
end
