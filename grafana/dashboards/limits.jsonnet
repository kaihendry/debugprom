#!/usr/bin/jsonnet -J vendor
local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;
local template = grafana.template;
local row = grafana.row;
local heatmapPanel = grafana.heatmapPanel;
local standardDims = { w: 12, h: 12 };

local exceededLimit = graphPanel.new(
  'Over the limit',
  bars=true,
  lines=false,
  min=0,
).addTargets([
  prometheus.target(
    |||
      aws_current > aws_limit
    |||,
    legendFormat='Active Users'
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
