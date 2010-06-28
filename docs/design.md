Noyes is designed to be fast, efficient, portable, flexible, and expressive.
The goal is to be able to make high quality real world production signal
processing systems with minimal development costs.  These are the design
decisions taken to achieve these goals.

## Noyes Has Multiple Independent Language Implementations
Noyes is written in C, Ruby, and Java.  These implementations are completely
independent.  However, the algorithms and designs patterns are identical.  This
means you can develop in any language you like but your final implentations is
extremely portable.  This kind of portability is increasingly important with
the explosion of new devices supporting limited languages as well as the
ability to work with companies that limit allowed language choices.

## All language implementations are wrapped with Ruby
You do not need to use the Ruby wrappers.  Even the core C implementation does
not require the Ruby wrappers to build.  It doesn't require ruby.h either.  So
no Ruby dependencies are ever created.  However, the Ruby wrappers make the
develop process much more expressive and efficient.  So even if you plan on
shipping a pure C product you are probably better off working in Ruby until all
your tests pass and you are feature complete. 

## Ruby wrappers choose implementations via modules.
The Ruby, C, and Java implementations are wrapped using the modules Noyes,
NoyesC, and NoyesJava, respectively.  Each module contains an identical set of
classes and functions.  Implementations can be intermixed.  That is, it is
possible to use Noyes::Preemphasizer seemlessly with NoyesJava::Segmenter or
with NoyesC::Segmenter.  The only exception is that Java and C implementations
cannot be mixed.  This is because the Java implementation is only available
when running JRuby and JRuby can't really do C yet.  The great thing about this
choice is it's possible to implement something quickly in Ruby and still
integrate it into something written in C.  The complete C port can be saved for
later if necessary.

## All implementations share a common set of comprehensive tests
All tests are written in Ruby.  A heavy emphasis is placed on thorough unit
testing striving for 100% coverage at all times.  The tests are fast and should
be run often.  The tests are also fine-grained.  If a test fails you should
have a very good idea of exactly where the bug is located.

## There are no critical external dependencies
To maximize portability none of the signal processing routines have any
depencencies outside of the standard libraries for the target language[1].  If
you can compile either C, Java, or Ruby then you can use probably use Noyes
without writing any additional code.

## There are very few internal dependencies.
As much as possible every class stands by itself.  If all you need is a windowing
routine that's all you need to take.  This leads to a very disentangled system.

[1] There is a dependency on Trollop, which is only used for some command line
utilities.  But none of the algorithms or the libraries have any dependencies
beyond the standard libraries that ship with language implementations.
