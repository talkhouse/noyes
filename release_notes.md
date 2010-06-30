# 0.9.1     June 30, 20101

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
