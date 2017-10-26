{% set ip = grains['ip_interfaces'].get('eth0', grains['ip_interfaces'].get('ens3', ['127.0.0.1']))[0] %}
consul:
  encrypt: random-string
  advertise: {{ ip }}
  ec2_tag_key: "consul"
  ec2_tag_value: "true"
  ec2_access_key_id: REPLACE_ME
  ec2_secret_access_key: REPLACE_ME
  client_addr: {{ ip }}
  bind_addr: {{ ip }}
  datacenter: us-east-1