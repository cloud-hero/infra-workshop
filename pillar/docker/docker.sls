{% set ip = grains['ip_interfaces'].get('eth0', grains['ip_interfaces'].get('ens3', ['127.0.0.1']))[0] %}
{% set host =  grains['id'] %}
docker:
  ip: {{ ip }}
  host: {{ host }}
  version: 17.03.0~ce-0~ubuntu-xenial
  opts: |
      -H tcp://0.0.0.0:2375 -H fd:// --cluster-store=consul://{{ ip }}:8500