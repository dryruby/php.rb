#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

GEMSPEC = Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'php'
  gem.homepage           = 'http://php.rubyforge.org/'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'A Ruby-to-PHP code generator.'
  gem.description        = 'PHP.rb is a Ruby-to-PHP code generator.'
  gem.rubyforge_project  = 'php'

  gem.authors            = ['Arto Bendiken']
  gem.email              = 'arto.bendiken@gmail.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS README UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.8.2'
  gem.requirements               = []
  gem.add_development_dependency 'rspec',          '>= 1.2.9'
  gem.add_development_dependency 'yard' ,          '>= 0.5.2'
  gem.add_runtime_dependency     'sexp_processor', '>= 3.0.3'
  gem.add_runtime_dependency     'ParseTree',      '>= 3.0.4'
  gem.post_install_message       = nil
end
