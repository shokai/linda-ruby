require File.expand_path 'test_helper', File.dirname(__FILE__)
require 'linda/test/tuple'

class TestTuple < MiniTest::Test
  include Linda::Test::Tuple

  def target_tuple
    Linda::Tuple
  end
end
