require File.expand_path 'test_helper', File.dirname(__FILE__)
require 'linda/test/tuplespace'

class TestTupleSpace < MiniTest::Test
  include Linda::Test::TupleSpace

  def target_tuplespace
    Linda::TupleSpace
  end

  def target_tuple
    Linda::Tuple
  end
end
