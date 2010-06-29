## Command Line Utilities

The program nrec will process almost any format of audio file into speech
features and send the data to a cloud hosted speech recognizer.  The resulting
transcript will be sent back and printed out.  The nrec program uses whatever
version of Ruby is on the path of your current environment.  It is compatible
with both ruby 1.9, ruby 1.8x, and JRuby.  When run under JRuby it can
optionally use a Java implementation, which is very fast.  See nrec --help for
more information.
