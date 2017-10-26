{% from "docker/map.jinja" import docker with context %}

docker_repo:
  pkgrepo.managed:
    - name: deb http://swrepo.cloudhero.io/docker/mirror/apt.dockerproject.org/repo {{ grains["os"]|lower }}-{{ grains["oscodename"] }} main
    - humanname: {{ grains["os"] }} {{ grains["oscodename"]|capitalize }} Docker Package Repository
    - keyid: f76221572c52609d
    - keyserver: keyserver.ubuntu.com
    - file: /etc/apt/sources.list.d/docker.list
    - refresh_db: True
    - require_in:
      - pkg: docker_package

docker_package:
  {%- if "version" in docker %}
  pkg.installed:
    - name: docker-engine
    - version: {{ docker.version }}
    - hold: True
  {%- else %}
  pkg.latest:
    - name: docker-engine
    - hold: True
  {%- endif %}

docker.service:
  file.managed:
    - template: jinja
    - name: /lib/systemd/system/docker.service
    - source: salt://docker/files/docker.service
  service.running:
    - enable: True
    - watch:
      - file: /lib/systemd/system/docker.service

docker-py requirements:
  pkg.installed:
    - name: python-pip
  pip.installed:
    - name: pip
    - upgrade: true

#docker (eg docker-py 2.1.0) python module currently not working. See: https://github.com/saltstack/salt/issues/40389
docker-py:
  pip.installed:
    - name: docker
    - require:
      - pkg: docker_package
      - pip: docker-py requirements
    - reload_modules: True

