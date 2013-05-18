Linda
=====
Tuple and TupleSpace implementation of Linda - coordinational language for parallel processing.

- https://github.com/shokai/linda-ruby
- https://rubygems.org/gems/linda


Installation
------------

    % gem install linda


Usage
-----
This rubygem provides

- on-memory Tuple/TupleSpace implementation
- common tests for your Linda implementation, such as using MongoDB or SQL.

[Sinatra::RocketIO::Linda](http://rubygems.org/gems/sinatra-rocketio-linda) is using linda rubygem inside.


Tuple Matching
--------------
Array Tuple `[1, 2]`

- matches `[1, 2]`
- matches `[1, 2, 3]`
- matches `[1, 2, "a"]`
- NOT matches `[1, "a"]`
- NOT matches `[2, 1]`

Hash Tuple {:a => 1, :b => 2}

- matches `{:a => 1, :b => 2}`
- matches `{:a => 1, :b => 2, :c => 3}`
- matches `{:a => 1, :b => 2, :user => "shokai"}`
- NOT matches `{:a => 1, :b => 5}`


Tuple/TupleSpace Functions
--------------------------

### TupleSpace#write( tuple, options={} )

- write a Tuple into TupleSpace.
- default : options = {:expire => 300}
  - expire 300(sec) after.
- similar to `out` function in C-Linda.

### TupleSpace#read( tuple )

- return a Tuple which matches in TupleSpace. return `nil` if not exists.
- similar to `rdp` function in C-Linda.


### TupleSpace#read( tuple, &callback(tuple) )

- callback a Tuple which matches in TupleSpace. wait until available.
- async function : it does not return a value.
- similar to `rd` function in C-Linda.


### TupleSpace#take( tuple )

- delete a Tuple, then return it which matches in TupleSpace. return `nil` if not exists.
- similar to `inp` function in C-Linda.


### TupleSpace#take( tuple, &callback(tuple) )

- delete a Tuple, then callback it which matches in TupleSpace. wait until available.
- async function : it does not return a value.
- similar to `in` function in C-Linda.


### TupleSpace#watch( tuple, &callback(tuple) )

- callback Tuples which matches when TupleSpace#write(tuple) is called.


Test
----

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
