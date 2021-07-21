test: # is ./exportme is working
	curl -s localhost:9100/metrics | grep aws
	curl -s localhost:9100/metrics | docker run -i --rm --entrypoint=promtool prom/prometheus check metrics

up:
	docker-compose up

down:
	docker-compose down -v
