#!/usr/bin/env ruby
require 'php'

PHP.eval do
  def unid
    return md5(uniqid(mt_rand, true))
  end

  echo "#{unid}\n"
end
