#!/usr/bin/env ruby
require 'php'

PHP.eval do
  for $key, $value in {'a' => 1, 'b' => 2, 'c' => 3}
    echo "#{$key} => #{$value}\n"
  end
end
