require 'noyes_java'
include NoyesJava
require 'ts_fast_java'
require 'ts_all'

make_test 'NoyesJava', 'Incremental'
make_test 'NoyesJava', 'FrontEnd8k'
#make_test 'NoyesJava', 'RubySpeed'
make_test 'NoyesJava', 'IncrementalSend'
make_test 'NoyesJava', 'Delta'
make_test 'NoyesJava', 'DSL'
