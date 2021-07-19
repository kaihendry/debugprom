test: # test if ./exportme is working
	curl -s localhost:9100/metrics | grep vpc

up:
	docker-compose up

down:
	docker-compose down -v
