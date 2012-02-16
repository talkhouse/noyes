# 1.2.0 February 16, 2012

Replace nrec with nfront.  The new nfront command is designed to work the skrym
recognizer.  The protocol is simple and can be easily incorporated into other
recognizers such as Sphinx or HTK. The mfccs it generates are compatible with
those used in Sphinx recognizers.  There are some minor difference with HTK,
however given suitable models htk recognizers work with them as well.

# 1.1.1    August 3, 2010

Added new command line option '--pattern' to bin/noyes.  It allows
more flexibility than the usual glob patterns as it uses Ruby's 'Dir'.
The bin/noyes command now converts files into htk format but with
sphinx style mfcc features.

Licensing was changed back to BSD to be more friendly.  See COPYING.

# 1.0.0    August 3, 2010

* Numerous refinements to the API, bug fixes, and additional documentation.

* Writing with Noyes should flow easily from the keyboard and should feel
  constent and meaningful.  Renamed c_impl to cext.  Didn't like typing c_impl
  so much.  Renamed many of the internal c array and matrix management
  functions for similar effect.

* Fixed bug in c-implementation of segmenter that caused incorrect
  segment counts.

* Fixed a number of leaks and memory errors by running the test
  suites under Valgrind.

* Changed the organization of test suites.  Added 'rake test:all' and
  changed 'rake test' to test only pure ruby on the default interpreter.

* Version 1.0.0 Test matrix

    Test Environment   | full | quick | C    | Java
    :------------------|:----:|:-----:|:----:|:----:
    Ruby  1.9.1 Ubuntu | pass | pass  | pass | NA
    JRuby 1.4.0 Ubuntu | pass | pass  | NA   | pass
    JRuby 1.5.1 Ubuntu | pass | pass  | NA   | pass
    Ruby  1.9.1 OS X   | pass | pass  | pass | NA
    Ruby  1.8.7 OS X   | pass | pass  | pass | NA
    JRuby 1.5.1 OS X   | pass | pass  | NA   | pass
    JRuby 1.4.0 OS X   | pass | pass  | NA   | pass
    Ruby  1.9.1 Win XP | pass | pass  | Unk  | NA
    Ruby  1.8.7 Win XP | fail | fail  | Unk  | NA
    JRuby 1.5.1 Win XP | pass | pass  | Unk  | pass
    Ruby  1.9.1 Vista  | Unk  | Unk   | Unk  | NA
    Ruby  1.8.7 Vista  | Unk  | Unk   | Unk  | NA
    iPhone 3G          | NA   | NA    | pass | NA
    iPhone 4G          | NA   | NA    | pass | NA


# 0.9.2     June 30, 2010

* Update gem description.

# 0.9.1     June 30, 2010

* Make end point detection more convenient for real time systems.  This is
  accomplished by adding a left shift operator that takes any size chunk of
  audio rather than something that is pre-segmented into centisecond chunks.

* Swith to yardoc.

# 0.9.0     May 28, 2010

* Adds end point detection.
* Fast tests are no consistant between implementations.  They
  have the same number of tests in the same order.

# 0.8.0     May 28, 2010 

* Adds C implementation under NoyesC package.
* The nrec utility includes many new parameters.  See nrec -h.
* Now nrec depends on Trollop.  
* Add a mock server, which performs fake recognition and saves input.
  see mock_noyes_server -h.
* I haven't tested the C compilation on Windows -- Just OSX and Linux.
  If for some reason you have a problem you can still use version 0.6.1.
  The algorithms and module names haven't changed.
