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
