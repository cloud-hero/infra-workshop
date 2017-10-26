include:
  - docker

swarmpull:
  dockerng.image_present:
    - name: cloudhero/swarm

{% if grains['docker'] == 'master' %}
swarm-manage:
  dockerng.running:
    - image: cloudhero/swarm
    - restart_policy: always
    - port_bindings: 4000:2375
    - cmd: "manage -H :2375 --replication --advertise={{ salt['pillar.get']('docker:ip', 'false') }}:4000 consul://{{ salt['pillar.get']('docker:ip', 'false') }}:8500"
    - require:
      - pkg: docker-engine

{% endif %}
{% if grains['docker'] == 'worker' %}

swarm-join:
  dockerng.running:
    - image: cloudhero/swarm
    - restart_policy: always
    - cmd: "join --advertise={{ salt['pillar.get']('docker:ip', 'false') }}:2375 consul://{{ salt['pillar.get']('docker:ip', 'false') }}:8500"
    - require:
      - pkg: docker-engine

{% endif %}
