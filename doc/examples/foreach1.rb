#!/usr/bin/env ruby
require 'php'

PHP.eval do
  for $fruit in ['apple', 'banana', 'cranberry']
    echo "#{$fruit}\n"
  end
end
