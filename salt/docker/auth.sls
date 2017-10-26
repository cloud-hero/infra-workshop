docker.auth:
  file.managed:
    - name: /root/.docker/config.json
    - makedirs: True
    - source: salt://docker/files/auth.jinja
