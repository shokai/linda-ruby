Linda
=====
Tuple and TupleSpace implementation of Linda

- https://github.com/shokai/linda-ruby
- https://rubygems.org/gems/linda


Installation
------------

    % gem install linda


Linda
-----
Linda is a coordination launguage for parallel programming.

- http://en.wikipedia.org/wiki/Linda_(coordination_language)
- http://ja.wikipedia.org/wiki/Linda


Usage
-----
Linda rubygem provides

- on-memory Tuple/TupleSpace implementation
- common tests for your Linda implementation, such as using KVS or RDB

[Sinatra::RocketIO::Linda](http://rubygems.org/gems/sinatra-rocketio-linda) is using Linda rubygem inside.


Tuple Matching
--------------
Array Tuple `[1, 2, 3]`

- matches `[1, 2, 3]`
- matches `[1, 2, 3, 4]`
- matches `[1, 2, 3, "a"]`
- NOT matches `[1, 2, "a"]`
- NOT matches `[2, 1, 3]`

```ruby
Linda::Tuple.new([1, 2]).match? [1, 2, 3]  # => true
Linda::Tuple.new([1, 2]).match? [1, "a"]   # => false
```

Hash Tuple {:a => 1, :b => 2}

- matches `{:a => 1, :b => 2}`
- matches `{:a => 1, :b => 2, :c => 3}`
- matches `{:a => 1, :b => 2, :name => "shokai"}`
- NOT matches `{:a => 1, :b => 5}`

```ruby
Linda::Tuple.new(:a => 1, :b => 2).match?(:a => 1, :b => 2, :name => "shokai")  # => true
Linda::Tuple.new(:a => 1, :b => 2).match?(:a => 1, :b => 5)  # => false
```

Tuple/TupleSpace Functions
--------------------------

### TupleSpace#write(tuple, options={})

- write a Tuple into TupleSpace.
- default : options = {:expire => 300}
  - expire 300(sec) after.
- similar to `out` function in C-Linda.

### TupleSpace#read(tuple)

- return a Tuple which matches in TupleSpace. return `nil` if not exists.
- similar to `rdp` function in C-Linda.


### TupleSpace#read(tuple, &callback(tuple))

- callback a Tuple which matches in TupleSpace. wait until available.
- async function : it does not return a value.
- similar to `rd` function in C-Linda.


### TupleSpace#take(tuple)

- delete a Tuple, then return it which matches in TupleSpace. return `nil` if not exists.
- similar to `inp` function in C-Linda.


### TupleSpace#take(tuple, &callback(tuple))

- delete a Tuple, then callback it which matches in TupleSpace. wait until available.
- async function : it does not return a value.
- similar to `in` function in C-Linda.


### TupleSpace#watch(tuple, &callback(tuple))

- callback Tuples which matches when TupleSpace#write(tuple) is called.


### TupleSpace#cancel(callback_id)

- remove read/take/watch callback by Callback-ID.


Test your Linda implementation
------------------------------

with [minitest](https://github.com/seattlerb/minitest).

### Test Tuple

`test/test_tuple.rb`
```ruby
require 'rubygems'
require 'minitest/autorun'
require 'linda/test/tuple'
require 'path/to/my/linda/tuple'  # load your Tuple class

class TestMyTuple < MiniTest::Test
  include Linda::Test::Tuple      # mix-in test code

  def target_tuple
    My::Linda::Tuple              # set your Tuple class name
  end
end
```

    % ruby test/test_tuple.rb


### Test TupleSpace

`test/test_tuplespace.rb`
```ruby
require 'rubygems'
require 'minitest/autorun'
require 'linda/test/tuplespace'
require 'path/to/my/linda/tuple'       # load your Tuple class
require 'path/to/my/linda/tuplespace'  # load your TupleSpace class

class TestMyTupleSpace < MiniTest::Test
  include Linda::Test::TupleSpace      # mix-in test code

  def target_tuple
    My::Linda::Tuple                   # set your Tuple class name
  end

  def target_tuplespace
    My::Linda::TupleSpace              # set your TupleSpace class name
  end
end
```

    % ruby test/test_tuplespace.rb


### Rake

`Rakefile`
```ruby
require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "test/test_*.rb"
end

task :default => :test
```

    % rake test

=> run all tests


Test
----
test this gem

    % gem install bundler
    % bundle install
    % rake test


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
