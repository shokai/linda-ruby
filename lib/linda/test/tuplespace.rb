module Linda
  module Test
    module TupleSpace

      def setup
        @space = target_tuplespace.new
      end

      def test_name
        assert_equal @space.name, "__default__"
        assert_equal target_tuplespace.new("foo").name, "foo"
      end

      def test_tuples
        @space.write [1]
        @space.write [1,2]
        @space.write :a => 10, :b => 20
        @space.write [1,2,"a"]
        assert_equal @space.size, 4
        assert_equal @space.tuples.size, 4
      end

      def test_write_read
        assert_equal @space.size, 0
        @space.write target_tuple.new [1,2,3]
        assert_equal @space.size, 1
        assert_equal @space.read([1,2]).data, [1,2,3]
        @space.write :a => 1, :b => 2, :c => 999
        @space.write :a => 1, :b => 2, :c => 3
        assert_equal @space.size, 3
        assert_equal @space.read(:a => 1, :c => 999).data, {:a => 1, :b => 2, :c => 999}
        assert_equal @space.read(:a => 1, :c => 999).data, {:a => 1, :b => 2, :c => 999}
        assert_equal @space.read(:a => 1).data, {:a => 1, :b => 2, :c => 3}
      end

      def test_write_read_callback
        assert_equal @space.size, 0
        _tuple1 = nil
        @space.read [1,2] do |tuple|
          _tuple1 = tuple.data
        end
        _tuple2 = nil
        @space.read [1,"a"] do |tuple|
          _tuple2 = tuple.data
        end
        _tuple3 = nil
        @space.read [1,2,3] do |tuple|
          _tuple3 = tuple.data
        end
        @space.write [1,2,3]
        assert_equal _tuple1, [1,2,3]
        assert_equal _tuple2, nil
        assert_equal _tuple3, [1,2,3]
        assert_equal @space.read([1]).data, [1,2,3]
        assert_equal @space.size, 1
        @space.write [1,2,4]
        assert_equal _tuple1, [1,2,3]
        assert_equal @space.size, 2
      end

      def test_take
        assert_equal @space.size, 0
        1.upto(3) do |i|
          @space.write [1,2,3,"a"*i]
        end
        assert_equal @space.size, 3
        assert_equal @space.take([1,2,3]).data, [1,2,3,"aaa"]
        assert_equal @space.size, 2
        @space.write :a => 1, :b => 2, :c => 3
        assert_equal @space.size, 3
        assert_equal @space.take([1,3]), nil
        assert_equal @space.take(:a => 1, :b => 2, :c => 4), nil
        assert_equal @space.take([1,2,3]).data, [1,2,3,"aa"]
        assert_equal @space.size, 2
        assert_equal @space.take([1,2,3]).data, [1,2,3,"a"]
        assert_equal @space.size, 1
        assert_equal @space.take(:b => 2, :a => 1).data, {:a => 1, :b => 2, :c => 3}
        assert_equal @space.size, 0
      end

      def test_take_callback
        assert_equal @space.size, 0
        _tuple1 = nil
        @space.take [1,2] do |tuple|
          _tuple1 = tuple.data
        end
        _tuple2 = nil
        @space.take [1,"a"] do |tuple|
          _tuple2 = tuple.data
        end
        _tuple3 = nil
        @space.read [1,2,3] do |tuple|
          _tuple3 = tuple.data
        end
        _tuple4 = nil
        @space.take [1,2,3] do |tuple|
          _tuple4 = tuple.data
        end
        1.upto(3) do |i|
          @space.write [1,2,3,"a"*i]
        end
        assert_equal @space.size, 1
        assert_equal _tuple1, [1,2,3,"a"]
        assert_equal _tuple2, nil
        assert_equal _tuple3, [1,2,3,"aa"]
        assert_equal _tuple4, [1,2,3,"aa"]
        assert_equal @space.take([1]).data, [1,2,3,"aaa"]
        assert_equal @space.size, 0
      end

      def test_watch
        assert_equal @space.size, 0
        _tuple1 = nil
        @space.take [1] do |tuple|
          _tuple1 = tuple.data
        end
        results = []
        @space.watch [1,2] do |tuple|
          results << tuple.data
        end
        @space.write [1,2,3]
        @space.write [1,2,"aa"]
        @space.write [1,"a",3]
        assert_equal _tuple1, [1,2,3]
        assert_equal @space.size, 2
        assert_equal results.size, 2
        assert_equal results[0], [1,2,3]
        assert_equal results[1], [1,2,"aa"]
      end

      def test_tuple_expire
        @space.write [1,2,999], :expire => false
        @space.write [1,2,3], :expire => 3
        @space.write [1,2,"a","b"], :expire => 2
        assert_equal @space.size, 3
        sleep 2
        @space.check_expire
        assert_equal @space.size, 2
        assert_equal @space.take([1,2]).data, [1,2,3]
        assert_equal @space.size, 1
        sleep 1
        assert_equal @space.take([1,2]).data, [1,2,999]
        assert_equal @space.size, 0
      end

      def test_cancel_read
        _tuple1 = nil
        _tuple2 = nil
        callback_id1 = @space.read [1,2] do |tuple|
          _tuple1 = tuple.data
        end
        callback_id2 = @space.read [1,2] do |tuple|
          _tuple2 = tuple.data
        end
        @space.cancel callback_id1
        @space.write [1,2,3]
        sleep 1
        assert_equal _tuple1, nil
        assert_equal _tuple2, [1,2,3]
        assert callback_id1 != callback_id2
      end

      def test_cancel_take
        _tuple1 = nil
        _tuple2 = nil
        callback_id1 = @space.take [1,2] do |tuple|
          _tuple1 = tuple.data
        end
        callback_id2 = @space.take [1,2] do |tuple|
          _tuple2 = tuple.data
        end
        @space.cancel callback_id1
        @space.write [1,2,3]
        sleep 1
        assert_equal _tuple1, nil
        assert_equal _tuple2, [1,2,3]
        assert callback_id1 != callback_id2
      end


      def test_cancel_watch
        _tuple1 = nil
        _tuple2 = nil
        callback_id1 = @space.watch [1,2] do |tuple|
          _tuple1 = tuple.data
        end
        callback_id2 = @space.watch [1,2] do |tuple|
          _tuple2 = tuple.data
        end
        @space.write [1,2,3]
        @space.cancel callback_id1
        @space.write [1,2,3,4]
        sleep 1
        assert_equal _tuple1, [1,2,3]
        assert_equal _tuple2, [1,2,3,4]
        assert callback_id1 != callback_id2
      end

    end
  end
end
