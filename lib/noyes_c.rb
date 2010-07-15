require "common"
require "cext/noyes_c"

# The NoyesC module encapsulates the C implementation of the Noyes library.
# Functionally, it is identical to the Noyes and NoyesJava modules.  The NoyesC
# implementation is composed of Ruby bindings, which are written in C and the
# core C routines.  The core C routines are not dependent on the Ruby wrappers
# or any Ruby libraries.  They can be compiled into pure C implementations
# without modification.  The underlying pure C implementation files can be
# identified by the 'c_' prefix.
#
# The underlying C implementation closely parallels the Noyes API.  For
# example, the following Ruby and C code are identical.
#
#
#     pre = NoyesC::Preemphasizer.new 0.97
#     preemphasized_data = pre << data
#
#
#     Preemphasizer *pre = preemphasizer_new(0.97);
#     Carr * preemphasized_data = preemphasizer_apply(data);
#
module Noyes
end
