#!/usr/bin/jsonnet -J vendor
local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local exceededLimit = graphPanel.new(
  'Over the limit',
).addTargets([
  prometheus.target(
    |||
      aws_current >= aws_limit
    |||,
    legendFormat='{{ type }}'
  ),
]);

dashboard.new(
  'AWS Limits',
  uid='limits-dashboard',
  tags=['aws'],
  editable=true,
  time_from='now-1h'
).addPanel(
  exceededLimit, {},
)
