## Overview
Noyes is a signal processing library.  It is designed to be fast, efficient,
portable, and expressive.  For more information on how this is accomplished
please read the design section.  It has enough signal processing routines to
produce features suitable for speech recognition, but it has many other uses.
This release contains independent implementations written in Ruby, C, and Java.

## Pronunciation
Typically pronounced the same as 'noise'.  But "No!... Yes!" is
considered acceptable if you say it with sufficient conviction to make people
think you have truly changed your mind.

## Why use Noyes?

* You need something small -- Not an entire recognition system or framework.
* You want a high degree of test coverage
* You want to be able to design and test using a scripting language.
* You want a version in pure C.
* You want a version in pure Java.
* You want Ruby wrappers for the above versions
* You want a version in pure Ruby.

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

## Requirements:
* Almost any version of Ruby & Rake
* Java, if you want to use the Java implementation
* A C compiler if you want to use the C version

Some of the utility scripts such as nrec may use sox, but
none of the core routines use it.

## Build instructions
  rake -T

## Additional Information

## Examples

A general purpose language is adequate for writing individual signal processing
routines, but that doesn’t mean it’s going to be particularly expressive for
grouping those routines into a coherent program. Programs that use signal
processing have their own special problems and needs. It’s helpful to provide a
domain specific notation that is expressive, but which doesn’t over-specify the
signal processing architecture. You don’t want strict design decisions in your
library that reduce the freedom of application designers to make the best
decisions for their applications.

Lets start with some basic input and output using minimal syntax:

  output = filter << input

If we’re willing to reuse variables we can use the filter operator, which
conveniently, looks like a filter:

  data >>= filter

Not only is this simple and concise, but it ends up being very readable, since
the different filters will line up perfectly to form a neat table, and there is
plenty of space for descriptive names.

```ruby
  data >>= hamming_windower
  data >>= power_spectrum_filter
  data >>= mel_filter
  data >>= log_compressor
  data >>= discrete_cosine_transform
```

Signal processing applications, in the general case, aren’t necessarily a
simple chain of routines. In general, they’re a directed graph of routines.
It’s possible represent a graph using just a handful of operators.

  a | b  # Filter a and b in parallel
  a & b  # Filter a and b in series

It’s possible to make arbitrarily complex combinations by grouping these
together with parenthesis. The idea behind this notation was suggested to me by
Bhiksha Raj. He noted that a notation similar to Bachus Naur Form would be
sufficient to represent these graph structures.

  a | b  # Filter a and b in parallel
  new_filter = a & b & (c|d) & (e|f) & g # Creates the following graph:

#                                        +-+   +-+
#                                     ---|c|---|e|---
#                                    /   +-+   +-+   \
#                                   |                 |
#                       +-+        +-+                v               +-+
#    new_filter = ----->|a|------->|b|------------------------------->|g|
#                       +-+        +-+                ^               +-+
#                                   |                 |
#                                    \   +-+   +-+    /
#                                     ---|d|---|f|----

We can then use the new filter like this:

  data_out = new_filter << data_in 

Or alternatively,

  data >>= new_filter

Even if you initially need just a simple chain for a particular program you
might find your needs change. Consider the following example. I once built a
speech recognition application using a signal processing library that dictated
a “pull” model for signal processing. The pull model means that each routine
“pulls” data from the previous routine whenever it needs data. This is fine
when you only need a chain. But eventually I needed to display the FFT. Now I
had a problem. That kind of branching didn’t work well with a pull model. I
would have had to implement extra caching, possibly some reference counting,
and rewrite all the signal processing components to make it work. There wasn’t
a good place to insert the logic that would determine where and how to route
the FFT data. What did I do? I ended up computing the processing twice because
I didn’t have time to rewrite everything to work the right way.

This syntax described so far doesn’t force you to use either push or pull
because you have direct control. The push model, however, is more flexible.
Once a component pushes its results it doesn’t need to save them. With a pull
model it has to cache everything until every component has pulled. It has no
way to know if a particular component will actually need the data. It can’t
optimize for that. The problems with pull models can be more severe than that,
but that’s a topic for another article.

Internal vs External DSL

An external DSL has its own parser. Because of that external DSLs can have
arbitrarily complicated syntax. However, they lose the ability to freely
intermix themselves with general purpose languages. Sometimes there is enough
flexibility to have the syntax you want and still use a general purpose
compiler. Then you can use an internal DSL. In that case you can be expressive
in your domain and still have all the power of a general purpose when you need
it. There are no rigid barriers. It’s the best of both worlds. Since all the
syntax I’ve described above is valid Ruby I chose to implement this library as
an internal DSL.

In the following example I’mfmixing generic Ruby code with the DSL syntax. In
this case the segmenter doesn’t necessarily have enough data to produce a
complete segment. So it may return nil. In that case there is no point in
passing nil to the next processor. It’s convenient to have general purpose flow
control to return to the top of the loop.

  pcm.each_slice 1230 do |data|
  data >>= preemphasizer
  data >>= segmenter
  next unless data
  data >>= hamming_windower
  ...

I once implemented a library similar to Noyes using an external DSL. It was
almost as expressive as this one, but it had the limitation that I had to stuff
my domain specific programming in a string. Since that string could not contain
any general purpose language it was more limiting. It created a more severe
boundary, and I had less control over layout. It was also detrimental to syntax
highlighting.

## Multiple Implementations

Different platforms tend to require different implementations and sometimes
different languages. Although I’ve used Ruby as the initial implementation for
this library it’s designed for fast porting to other languages. This is
accomplished by emphasising testability. Unit tests don’t need to be ported,
and they test at a very fine-grained level. You might only need to write tens
of lines implementation between running tests. That way, when you do have a
bug, you won’t have to search far for an answer. And of course, you’ve got
existing implementations you can study.

All implementations are accessible from Ruby. Each implementation is in its own
namespace. For the Java version you include NoyesJava, for example. If somebody
were to make an Unlambda version they would probably use the namespace
NoyesUnlambda. Alternative implementations can be used alone, or with Ruby
bindings. It’s possible you ultimately need to run on a platform that doesn’t
have Ruby, but you’ll probably find it helps during development and testing.

## Testing

The tests are fine grained. You don’t need to implement an entire MFCC front
end just to know that your preemphasis isn’t working. I’ve had to debug front
ends that don’t have fine grained unit tests. I don’t enjoy it. This
implementation has avoided difficult to test code. Constructors, as a general
rule, don’t do any work. Anything that does any amount of work produces some
easily testable set of values. Almost everything can be isolated into small
unrelated testable chunks.

While test coverage is more or less 100% you may find that your parameters need
to be tested if you have an unusual input waveform. For example, maybe you have
a unique sample rate or number of bits. In that case there is sample data and a
reference recognizer you can use to test against. See the documentation for
information. In particular, see nrec, a command line program that processes
audio files and has the results recognized using a free cloud-based recognizer.

## No Configuration Files

Configuration files are sometimes a necessary consequence of using a compiled
language. Recompiling a language may be impractical when experimenting with
parameters. But with a dynamic languages this isn’t an issue. In this case a
configuration file would be unnecessarily rigid and does not fit with the
minimal architecture philosophy of this system. It would take away a decision
that rightfully belongs to the application developer. Often configuration data
is more concise and readable in a dynamic language than it would be in a
configuration file anyway – particularly if the format is XML. Also,
configuration files, not being programmable, are trouble for applications that
need dynamic settings.

[Documentation](http://rdoc.info/projects/talkhouse/noyes),
[Source Code](http://github.com/talkhouse/noyes),
[Ruby Gem](http://rubygems.org/gems/noyes),
[Talkhouse Blog: A Ruby DSL for Signal Processing](http://www.talkhouse.com/ruby-dsl.html)
[Talkhouse](http://www.talkhouse.com)
