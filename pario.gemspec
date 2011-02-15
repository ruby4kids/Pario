 # -*- encoding: utf-8 -*-

pario_path = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(pario_path) unless $LOAD_PATH.include?(pario_path)
require 'pario/version'

Gem::Specification.new do |s|
  s.name          = 'pario'
  s.version       = Pario::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Bill Davenport', 'Anthony Burns']
  s.email         = ['bill@infoether.com', 'anthony@infoether.com']
  s.homepage      = 'http://github.com/ruby4kids/pario'
  s.summary       = %q{A Gosu game framework}
  s.description   = %q{Pario is a Gosu game framework that helps to give you structure and a start for creating games}
  
  s.required_rubygems_version = '>= 1.3.7'
  s.rubyforge_project         = 'pario'
  
  s.add_dependency('gosu',  '~> 0.7.26')
  
  s.files              = `git ls-files`.split("\n")
  s.executables        = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.default_executable = 'pario'
  s.require_paths      = ['lib']
end
