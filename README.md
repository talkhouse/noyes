## Overview
Noyes is a signal processing library.  It is unique in that it is designed to
be fast, efficient, portable, and expressive.  For more information on how this
is accomplished please read the design section.  It has enough signal
processing routines to produce features suitable for speech recognition, but it
has many other uses.

## Pronunciation
Typically pronounced the same as 'noise'.  But "No!... Yes!" is
considered acceptable if you say it with sufficient conviction to make people
think you have truly changed your mind.

## Raison d'être
Noyes is a general purpose signal processing tool that is flexible enough for
many purposes.  However, it exists because there is a need for low-latency high
quality speech recognition on portable wireless devices.  The most powerful
speech recognizers are very large with huge models running on powerful cloud
based systems.  But transmitting raw audio to these recognizers creates too
much latency because raw audio uses too much bandwidth.  By sending compressed
features instead of raw audio the bandwidth can be greatly reduced without
compromising recognition accuracy.  In some cases the effect of inadequate
bandwidth on latency can be reduced to zero.

Because hand sets require different implementations the Noyes library is
designed to quickly and efficiently work with and develop multiple underlying
implementations.  All implementations are accessible via a high level dynamic
language that includes a very expressive domain specific language for handling
signal processing routines.  In addition, all implementations share unit tests
written in a high level dynamic language.

Noyes is implemented entirely in Ruby.  It's also implemented entirely in Java.
The Java version has Ruby bindings too.  So you can have Java's speed from
Ruby.  If you need a pure Java version you can use the generated jar.  There is
a lot of flexibility without a lot of overhead.  All versions share the same
unit tests, which are written in Ruby.

The design goal is to have signal processing routines that are so simple and so
disentangled from the overall system that anyone could extract any of the
routines and use them elsewhere with little trouble.  Benchmarks are included.

This library places an emphasis on expressiveness without sacrificing ultimate
performance.  It does so by supporting multiple implementations each with Ruby
bindings.  The pure Ruby version, while not fast, is often adequate for
development and is the best place to add new routines.    

For examples of how to link with different implementations see the test section
of the Rakefile.  At present only the pure Ruby implementation is exposed via
the gem.

## Requirements:
  Almost any version of ruby & rake.
  Java, if you want to use the Java implementation
  A C compiler if you want to use the C version

  Some of the utility scripts such as nrec and jrec may use sox, but
  none of the core routines use it.

## Build instructions
  rake -T


== Command Line Utilities

The program nrec will process almost any format of audio file into speech
features and send the data to a cloud hosted speech recognizer.  The resulting
transcript will be sent back and printed out.  The nrec program uses whatever
version of Ruby is on the path of your current environment.  It is compatible
with both ruby 1.9, ruby 1.8x, and JRuby.  When run under JRuby it can
optionally use a Java implementation, which is very fast.  See nrec --help for
more information.

== Assessing Performance for Wireless Devices

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
