# Filter operator example.
# Each example below is the data on the left being operated on by the filter on
# the right.  This is similar to the way the += operator works for numbers. The
# data is not modified in place currently and it should probably stay that way.
# It could be if efficiency demanded it, but that would require a bit more care
# to avoid side effects when using the API.  The >>= actually looks like a
# filter.  

    data = (1..12).to_a
    segmenter = Segmenter.new 4, 2 # window size, window shift 
    hamming_filter = HammingWindow.new 4 # window size
    power_spec_filter = PowerSpectrumFilter.new 8 # number of ffts

    data >>= segmenter
    data >>= hamming_filter
    data >>= power_spec_filter
    data >>= dct_filter

# You can expand the >>= operator out, but I think the flow is worse and there
# is more repetition, particularly when you have a lot of filters in sequence.
# This is perfectly valid syntax though. Also, this is very useful if you don't
# want to keep a reference to your original data.

    pcm_data = (1..12).to_a
    segmenter = Segmenter.new
    hamming_filter = HammingWindow.new 4
    segmented_data = segmenter << pcm_data, 4, 2
    hamming_data = hamming_filter <<  segmented_data
    power_spectrum data = power_spec_filter hamminging_data, 8
    dct_data = dct_filter << power_spectrum_data

# Here is an older version with function calls instead of operator overloading.
# The trouble with it is that the flow is hard to follow, and there is
# repetition.  Filter and process are really synonyms. And this requires
# repeating the data component twice.   Also, power spec is a function here
# with additional arguments.  I think I'd rather have the configuration
# details, such as number of ffts all grouped at the top.  It's easier to
# follow this way.

    data = (1..12).to_a
    seg = Segmenter.new
    ham = HammingWindow.new 4
    segments = segmenter.process data, 4, 2
    hamming_ = hamming_filter.process segments
    power = power_spec.filter hamming, 8
    dct = dct.process power 
