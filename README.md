PHP.rb: A Ruby to PHP Code Generator
====================================

PHP.rb translates [Ruby](http://www.ruby-lang.org/) code into
[PHP](http://www.php.net/) code.

Usage
-----

    require 'php'

### Checking the available PHP version

    PHP.version                               #=> "5.3.1"

### Generating PHP code using a Ruby block

    PHP.generate { echo "Hello, world!\n" }   #=> PHP::Program(...)

### Evaluating generated PHP on the fly

    PHP.eval { echo "Hello, world!\n" }

Examples
--------

### `foreach` loops (1)

    for fruit in ['apple', 'banana', 'cranberry']
      echo "#{fruit}\n"
    end

    <?php
    foreach (array("apple", "banana", "cranberry") as $fruit) {
      echo($fruit . "\n");
    }

### `foreach` loops (2)

    for key, value in {'a' => 1, 'b' => 2, 'c' => 3}
      echo "#{key} => #{value}\n"
    end

    <?php
    foreach (array("a" => 1, "b" => 2, "c" => 3) as $key => $value) {
      echo($key . " => " . $value . "\n");
    }

Reference
---------

Ruby input                        | PHP output
----------------------------------|--------------------------------------
`nil`                             | `NULL`
`false`                           | `FALSE`
`true`                            | `TRUE`
`42`                              | `42`
`3.1415`                          | `3.1415`
`"Hello, world!"`                 | `"Hello, world!"`
`"<#{url}>"`                      | `"<" . $url . ">"`
`/a-z/`                           | `'/a-z/'`
`[]`                              | `array()`
`[1, 2, 3]`                       | `array(1, 2, 3)`
`{}`                              | `array()`
`{"a" => 1, "b" => 2, "c" => 3}`  | `array("a" => 1, "b" => 2, "c" => 3)`
`$foo`                            | `$GLOBALS['foo']`
`$foo = 123`                      | `$GLOBALS['foo'] = 123`
`foo`                             | `$foo`
`foo = 123`                       | `$foo = 123`
`def foo(x, y); end`              | `function foo($x, $y) {}`
`a << b`                          | `$a . $b` (*)
`a + b`                           | `$a + $b`
`a - b`                           | `$a - $b`
`a * b`                           | `$a * $b`
`a / b`                           | `$a / $b`
`a % b`                           | `$a % $b`
`a = b`                           | `$a = $b`
`a == b`                          | `$a == $b`
`a === b`                         | `$a === $b` (*)
`a != b`                          | `$a != $b`
`a < b`                           | `$a < $b`
`a > b`                           | `$a > $b`
`a <= b`                          | `$a <= $b`
`a >= b`                          | `$a >= $b`

Documentation
-------------

* <http://php.rubyforge.org/>

Dependencies
------------

* [Open4](http://gemcutter.org/gems/open4) (>= 1.0.1)
* [ParseTree](http://gemcutter.org/gems/) (>= 3.0.4)
* [RubyParser](http://gemcutter.org/gems/) (>= 2.0.4)
* [SexpProcessor](http://gemcutter.org/gems/sexp_processor) (>= 3.0.3)

Installation
------------

The recommended installation method is via RubyGems. To install the latest
official release from Gemcutter, do:

    % [sudo] gem install php

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/php.git

Alternatively, you can download the latest development version as a tarball
as follows:

    % wget http://github.com/bendiken/php/tarball/master

Resources
---------

* <http://php.rubyforge.org/>
* <http://github.com/bendiken/php>
* <http://gemcutter.org/gems/php>
* <http://rubyforge.org/projects/php/>
* <http://raa.ruby-lang.org/project/php/>

Authors
-------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>

License
-------

PHP.rb is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.
