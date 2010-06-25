require 'ts_fast_ruby'
require 'ts_all'
include Noyes
make_test 'Noyes', 'Incremental'
make_test 'Noyes', 'FrontEnd8k'
#make_test 'Noyes', 'RubySpeed'
make_test 'Noyes', 'IncrementalSend'
make_test 'Noyes', 'Delta'
make_test 'Noyes', 'DSL'
