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
      aws_current / aws_limit * 100
    |||,
    legendFormat='{{ type }}'
  ),
]);

// https://www.robustperception.io/reduce-noise-from-disk-space-alerts
// TODO: 100% threshold
local predictedExceed = graphPanel.new(
  'Predicted to be over the limit in four hours',
).addTargets([
  prometheus.target(
    |||
      predict_linear(aws_current[5m], 4 * 3600) / aws_limit * 100
    |||,
    legendFormat='{{ type }}'
  ),
]);


dashboard.new(
  'AWS Limits',
  uid='limits-dashboard',
  tags=['aws'],
  editable=true,
  time_from='now-5m'
).addPanel(
  exceededLimit, gridPos={
    h: 10,
    w: 24,
    x: 0,
    y: 0,
  },
).addPanel(
  predictedExceed, gridPos={
    h: 10,
    w: 24,
    x: 0,
    y: 10,
  },
)
