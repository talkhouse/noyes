require 'yaml'

module TestEndOfUtterance
  DD = 'data/noyes'
  def setup
    # Unback some PCM
    packed = IO.read("#{DD}/raw.dat")
    @pcm = packed.unpack 'n*'
    @pcm = @pcm.map{|d| to_signed_short(d).to_f}
    @frames_per_10_millisecs = 80

    # Create segments and expected speech for SpeechTrimmer tests.
    leader = 5; trailer = 5
    segmenter = Segmenter.new 80, 80
    @segments = segmenter << @pcm
    ecs = 50 # End centiseconds.
    scs = 20 # Start centiseconds.

    # Determine expected values.
    is_speech = YAML.load IO.read "#{DD}/is_speech.yml"
    speech_start = is_speech.index true
    false_count = 0
    speechlen = is_speech.drop(speech_start).each_with_index do |s, i|
      false_count = s ? 0 : false_count + 1
      break i + 1 - ecs if false_count == ecs
      i + 1
    end
    @expected_speech = @segments[speech_start - leader,
                               speechlen + trailer + leader]
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
    # Get and test results from speech trimmer.
    trimmer = SpeechTrimmer.new
    speech = @segments.inject [] do |memo, centisec|
      trimmer.enqueue centisec unless trimmer.eos?
      while x = trimmer.dequeue
        memo << x
      end
      break memo if trimmer.eos?
      memo
    end

    #open('spc.raw', 'wb') {|f| f.write speech.flatten.pack 'n*'}
    assert_m @expected_speech, speech, 5
    assert_equal @expected_speech, speech
  end
  def test_speech_trimmer_without_presegmenting
    # Get and test results from speech trimmer.
    trimmer = SpeechTrimmer.new 8000
    speech = trimmer << @pcm
    #assert_m @expected_speech, speech, 5
    assert_equal @expected_speech, speech
    assert_equal nil, trimmer << @pcm
  end
  def test_speech_trimmer_on_chunks_of_audio
    # Get and test results from speech trimmer.
    trimmer = SpeechTrimmer.new 8000
    speech = []
    @pcm.each_slice(7) do |slice|
      trimmed = trimmer << slice
      speech << trimmed if trimmed
    end
    speech.flatten!
    assert_equal @expected_speech.flatten, speech
    assert_equal nil, trimmer << @pcm
  end
end
