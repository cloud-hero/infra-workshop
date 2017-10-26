consul-config:
  file.managed:
    - name: /etc/consul.d/server.json
    - source: salt://consul/config.jinja
    - template: jinja
    - mode: 400
    - makedirs: true
