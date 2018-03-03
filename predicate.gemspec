$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'predicate/version'

Gem::Specification.new do |s|
  s.name        = 'predicate'
  s.version     = Predicate::VERSION
  s.date        = '2016-07-19'
  s.summary     = "Predicate provides a simple class and processors to encode and manipulate (tuple) predicates"
  s.description = "Predicate provides a simple class and processors to encode and manipulate (tuple) predicates"
  s.authors     = ["Bernard Lambeau"]
  s.email       = 'blambeau@gmail.com'
  s.files       = Dir['LICENSE.md', 'Gemfile','Rakefile', '{bin,lib,spec,tasks}/**/*', 'README*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'http://github.com/enspirit/predicate'
  s.license     = 'MIT'

  s.add_runtime_dependency "sexpr", "~> 0.6.0"
  s.add_runtime_dependency "path", "~> 2.0"

  s.add_development_dependency "rake", "~> 10"
  s.add_development_dependency "rspec", "~> 3.6"
  s.add_development_dependency "sequel"
  s.add_development_dependency "sqlite3"
end
