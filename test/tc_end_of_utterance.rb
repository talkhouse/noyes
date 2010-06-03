require 'yaml'
module TestEndOfUtterance
  DD = 'data/noyes'
  def setup
    packed = IO.read("#{DD}/raw.dat")
    @pcm = packed.unpack 'n*'
    @pcm = @pcm.map{|d| to_signed_short(d).to_f}
    @frames_per_10_millisecs = 80
  end
  def test_bent_frame_marker
    frame_marker = BentFrameMarker.new
    slices = []
    @pcm.each_slice @frames_per_10_millisecs do |frame|
      slices << (frame_marker << frame)
    end
    expected = YAML.load IO.read "#{DD}/is_speech.yml"
    assert_equal expected.size, slices.size, 'is_speech wrong length'
    assert_equal expected, slices, 'is_speech failed'
  end
  def test_end_of_utterance_detection
    # Parameters and data.
    leader = 1; trailer = 1
    segmenter = Segmenter.new 80, 80
    segments = segmenter << @pcm

    # Determine expected values.
    is_speech = YAML.load IO.read "#{DD}/is_speech.yml"
    speech_start = is_speech.index true
    false_count = 0
    speech_end = is_speech.drop(speech_start).each_with_index do |s, i|
      false_count = s ? 0 : false_count + 1
      break i if false_count == 40
      i
    end
    expected_speech = segments[speech_start - leader, speech_end + trailer]

    # Get and test results from speech trimmer.
    trimmer = SpeechTrimmer.new
    speech = segments.inject [] do |memo, centisec|
      x = trimmer << centisec
      memo << x if x
      break memo if trimmer.eos?
      memo
    end
    speech.concat trimmer.get_queue
    assert_equal expected_speech, speech
  end
end
