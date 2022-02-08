pg.start: pg.stop
	docker run --name predicate-pg-tests -p5432:5432 -e POSTGRES_PASSWORD=password -d postgres
	until [ pg_isready ]; do \
		sleep 0.1; \
	done;

pg.stop:
	docker stop predicate-pg-tests || true
	docker rm predicate-pg-tests || true

tests.unit:
	bundle exec rake test

tests.pg: pg.start
	PREDICATE_PG_URL=postgres://postgres:password@localhost/postgres bundle exec rake test

tests: tests.unit

package:
	bundle exec rake package

gem.push:
	ls pkg/predicate-*.gem | xargs gem push
