* Prometheus http://localhost:9090
* Node exporter with textfile collector http://localhost:9100/metrics
* Request sink http://localhost:8000/admin
* Alert manager http://localhost:9093/
* Grafana http://localhost:3000/

# How to federate particular metrics

For example the metrics inside `exportme/metrics.prom`, can be scraped from the
Prometheus (that scrapes local exporters) through federation, which supplies
[aggregated time series
data](https://prometheus.io/docs/prometheus/latest/federation/#hierarchical-federation).

	$ curl -G --data-urlencode 'match[]={__name__=~"aws.+"}' http://localhost:9090/federate
	# TYPE aws_current untyped
	aws_current{instance="node-exporter:9100",job="node-exporter",region="us-east-1",type="vpcs"} 1 1628731321833
	aws_current{instance="node-exporter:9100",job="node-exporter",region="us-east-1",type="vpcs-gateway"} 1 1628731321833
	# TYPE aws_limit untyped
	aws_limit{instance="node-exporter:9100",job="node-exporter",region="us-east-1",type="vpcs"} 5 1628731321833
	aws_limit{instance="node-exporter:9100",job="node-exporter",region="us-east-1",type="vpcs-gateway"} 5 1628731321833
