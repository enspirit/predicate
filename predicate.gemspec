$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'predicate/version'
require 'date'

Gem::Specification.new do |s|
  s.name        = 'predicate'
  s.version     = Predicate::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Predicate provides a simple class and processors to encode and manipulate (tuple) predicates"
  s.description = "Predicate provides a simple class and processors to encode and manipulate (tuple) predicates"
  s.authors     = ["Bernard Lambeau"]
  s.email       = 'blambeau@gmail.com'
  s.files       = Dir['LICENSE.md', 'Gemfile','Rakefile', '{bin,lib,spec,tasks}/**/*', 'README*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'http://github.com/enspirit/predicate'
  s.license     = 'MIT'

  s.add_runtime_dependency "sexpr", "~> 1.1"
  s.add_runtime_dependency "minitest", ">= 5.0"

  s.add_development_dependency "rake", "~> 13"
  s.add_development_dependency "rspec", "~> 3"
  s.add_development_dependency "sequel"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pg"
end
