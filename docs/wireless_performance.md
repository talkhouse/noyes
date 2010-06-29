## Command Line Utilities

The program nrec will process almost any format of audio file into speech
features and send the data to a cloud hosted speech recognizer.  The resulting
transcript will be sent back and printed out.  The nrec program uses whatever
version of Ruby is on the path of your current environment.  It is compatible
with both ruby 1.9, ruby 1.8x, and JRuby.  When run under JRuby it can
optionally use a Java implementation, which is very fast.  See nrec --help for
more information.

## Assessing Performance for Wireless Devices

It's important to note that the performance characteristics of live data and
recorded data are different.   Any delay experience by a user starts from the
time they stop speaking.  In contrast, any delay experienced when processing a
file starts from the time a file starts processing.  For that reason file
processing always seems slower.  Modern recognizers are easily capable of
exceeding real time performance so that it not a factor.  The delay experienced
by a user is typically due to the time required to transmit the audio to the
recognizer and the time required to detect end of utterance, assuming end of
utterance detection is used.  

If end of utterance detection is used the recognizer must wait until it has
sufficient evidence to be reasonably sure the user has stopped talking.  This
could mean that a suitable period of silence has passed which means the user
incurs a slight but unavoidable delay.  End of utterance detection also could
mean the grammar or language model does not allow for any other reasonable
possibility even if more data were available, which may mean no delay at all
(or even a negative delay in some cases).

If the bandwidth of the network is low enough, which is often the case for the
data channel of portable wireless handsets, it will take time for raw
uncompressed audio to traverse the network.   By computing features on the
handset it is possible to have significant reduction in bandwidth requirements
eliminating much of the latency.  These features in turn may then be compressed
for further bandwidth reduction.  This method exceeds what is possible with
alternative methods of audio compression.  Further, it eliminates many of the
distortion components that may compromise recognition accuracy.

If all you want is a rough feeling of how responsive speech recognition will be
over your network try speaking an utterance at the same time you enter a
command to have a prerecorded utterance recognized.  You'll probably be
surprised by how quickly the network is able to respond.  You may find that the
Java implementation feels like instant response even though it takes time for
the JVM to launch.  Ruby 1.9 is actually surprisingly quick on a reasonably
powerful laptop.

