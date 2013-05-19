module Linda
  module Test
    module Tuple

      def test_array_tuple
        tuple = target_tuple.new([1,2,:a])
        assert_equal tuple.data, [1,2,:a]
        assert_equal tuple.type, Array
        assert_equal JSON.parse(tuple.to_json), [1,2,"a"]
      end

      def test_hash_tuple
        tuple = target_tuple.new(:a => 1, :b => 2)
        assert_equal tuple.data, {:a => 1, :b => 2}
        assert_equal tuple.type, Hash
        assert_equal JSON.parse(tuple.to_json), {"a" => 1, "b" => 2}
      end

      def test_match_array_tuple
        tuple = target_tuple.new [1,2,3]
        assert tuple.match? target_tuple.new [1,2,3]
        assert tuple.match? target_tuple.new [1,2,3,4]
        assert !tuple.match?(target_tuple.new [1,2])
        assert !tuple.match?(target_tuple.new [1,"a",3])
        assert !tuple.match?(target_tuple.new :a => 1, :b => 2)
        tuple = target_tuple.new ["a","b","c"]
        assert tuple.match? target_tuple.new ["a","b","c"]
        assert tuple.match? target_tuple.new ["a","b","c","d","efg",123,"h"]
        assert !tuple.match?(target_tuple.new ["a","b"])
        assert !tuple.match?(target_tuple.new ["a","b",789])
        assert !tuple.match?(target_tuple.new :foo => 1, :bar => 2)
      end

      def test_match_array
        tuple = target_tuple.new [1,2,3]
        assert tuple.match? [1,2,3]
        assert tuple.match? [1,2,3,4]
        assert !tuple.match?([1,2])
        assert !tuple.match?([1,"a",3])
        assert !tuple.match?(:a => 1, :b => 2)
        tuple = target_tuple.new ["a","b","c"]
        assert tuple.match? ["a","b","c"]
        assert tuple.match? ["a","b","c","d","efg",123,"h"]
        assert !tuple.match?(["a","b"])
        assert !tuple.match?(["a","b",789])
        assert !tuple.match?(:foo => 1, :bar => 2)
      end

      def test_match_hash_tuple
        tuple = target_tuple.new :a => 1, :b => 2
        assert tuple.match? target_tuple.new :a => 1, :b => 2
        assert tuple.match? target_tuple.new :a => 1, :b => 2, :c => 3
        assert tuple.match? target_tuple.new :a => 1, :b => 2, :c => {:foo => "bar"}
        assert !tuple.match?(target_tuple.new :a => 0, :b => 2)
        assert !tuple.match?(target_tuple.new :b => 2, :c => 3)
        assert !tuple.match?(target_tuple.new [1,2,3])
      end

      def test_match_hash
        tuple = target_tuple.new :a => 1, :b => 2
        assert tuple.match? :a => 1, :b => 2
        assert tuple.match? :a => 1, :b => 2, :c => 3
        assert tuple.match? :a => 1, :b => 2, :c => {:foo => "bar"}
        assert !tuple.match?(:a => 0, :b => 2)
        assert !tuple.match?(:b => 2, :c => 3)
        assert !tuple.match?([1,2,3])
      end
    end
  end
end
