tests:
	bundle exec rake test

package:
	bundle exec rake package

gem.push:
	ls pkg/predicate-*.gem | xargs gem push
