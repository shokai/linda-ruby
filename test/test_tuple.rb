require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestTuple < MiniTest::Test
  def test_match_array_tuple
    tuple = Linda::Tuple.new [1,2,3]
    assert tuple.match? Linda::Tuple.new [1,2,3]
    assert tuple.match? Linda::Tuple.new [1,2,3,4]
    assert !tuple.match?(Linda::Tuple.new [1,2])
    assert !tuple.match?(Linda::Tuple.new [1,"a",3])
    assert !tuple.match?(Linda::Tuple.new :a => 1, :b => 2)
    tuple = Linda::Tuple.new ["a","b","c"]
    assert tuple.match? Linda::Tuple.new ["a","b","c"]
    assert tuple.match? Linda::Tuple.new ["a","b","c","d","efg",123,"h"]
    assert !tuple.match?(Linda::Tuple.new ["a","b"])
    assert !tuple.match?(Linda::Tuple.new ["a","b",789])
    assert !tuple.match?(Linda::Tuple.new :foo => 1, :bar => 2)
  end

  def test_match_array
    tuple = Linda::Tuple.new [1,2,3]
    assert tuple.match? [1,2,3]
    assert tuple.match? [1,2,3,4]
    assert !tuple.match?([1,2])
    assert !tuple.match?([1,"a",3])
    assert !tuple.match?(:a => 1, :b => 2)
    tuple = Linda::Tuple.new ["a","b","c"]
    assert tuple.match? ["a","b","c"]
    assert tuple.match? ["a","b","c","d","efg",123,"h"]
    assert !tuple.match?(["a","b"])
    assert !tuple.match?(["a","b",789])
    assert !tuple.match?(:foo => 1, :bar => 2)
  end

  def test_match_hash_tuple
    tuple = Linda::Tuple.new :a => 1, :b => 2
    assert tuple.match? Linda::Tuple.new :a => 1, :b => 2
    assert tuple.match? Linda::Tuple.new :a => 1, :b => 2, :c => 3
    assert tuple.match? Linda::Tuple.new :a => 1, :b => 2, :c => {:foo => "bar"}
    assert !tuple.match?(Linda::Tuple.new :a => 0, :b => 2)
    assert !tuple.match?(Linda::Tuple.new :b => 2, :c => 3)
    assert !tuple.match?(Linda::Tuple.new [1,2,3])
  end

  def test_match_hash
    tuple = Linda::Tuple.new :a => 1, :b => 2
    assert tuple.match? :a => 1, :b => 2
    assert tuple.match? :a => 1, :b => 2, :c => 3
    assert tuple.match? :a => 1, :b => 2, :c => {:foo => "bar"}
    assert !tuple.match?(:a => 0, :b => 2)
    assert !tuple.match?(:b => 2, :c => 3)
    assert !tuple.match?([1,2,3])
  end
end
