require 'common'
require 'ruby_impl/dct'
require 'ruby_impl/delta'
require 'ruby_impl/filter'
require 'ruby_impl/mel_filter'
require 'ruby_impl/hamming_window'
require 'ruby_impl/log_compress'
require 'ruby_impl/live_cmn'
require 'ruby_impl/discrete_fourier_transform'
require 'ruby_impl/power_spec'
require 'ruby_impl/preemphasis'
require 'ruby_impl/segment'
require 'ruby_impl/compression'
require 'ruby_impl/bent_cent_marker'
require 'ruby_impl/speech_trimmer'

# The Noyes module encapsulates all pure Ruby implemenations of the Noyes
# library.  At present there is also an equivalent NoyesC and NoyesJava modules
# that encapsulate C and Java implementations, respectively.  This, it is
# possible to choose an implementation programmatically simply by choosing a
# module.  It is even possible to mix and match components with different
# implementations.  The only limitation on this is that Java implementations
# only work under JRuby and C implementation only work under everything else.
# So C and Java implementations cannot be used at the same time.  That's a
# limitation of the current Ruby interpreters, not the Noyes library.
module Noyes
end
