require 'test/unit'
require 'tc_module'

class Concrete < Test::Unit::TestCase
  include TestMe
  include Area51
end
