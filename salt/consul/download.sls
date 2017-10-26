include:
  - general.tools

consul-get:
  archive.extracted:
    - name: /usr/local/sbin
    - source: https://releases.hashicorp.com/consul/0.8.3/consul_0.8.3_linux_amd64.zip
    - source_hash: md5=d6bc0898ea37ae2198370a9e1978d1bb
    - archive_format: zip
    - if_missing: /usr/local/sbin/consul
    - extract_perms: False
    - use_cmd_unzip: True
    - enforce_toplevel: False

  file.managed:
    - name: /usr/local/sbin/consul
    - mode: 700
