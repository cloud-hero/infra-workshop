{% set host =  grains['id'] %}
include:
  - docker.install

registratorpull:
  dockerng.image_present:
    - name: cloudhero/registrator

registrator-{{ host }}:
  dockerng.running:
    - image: cloudhero/registrator
    - restart_policy: always
    - binds: /var/run/docker.sock:/tmp/docker.sock
    - cmd: '-cleanup -ttl 600 -ttl-refresh 300 -resync 600 -ip="{{ salt['pillar.get']('docker:ip', 'false') }}" consul://{{ salt['pillar.get']('docker:ip', 'false') }}:8500'
    - hostname: registrator
    - require:
      - pkg: docker-engine
