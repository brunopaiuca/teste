stack-install-unzip:
  pkg.installed:
    - pkgs:
      - unzip

stack-install-consul:
  file.managed:
    - name: /tmp/consul.zip
    - source: https://releases.hashicorp.com/consul/1.5.0/consul_1.5.0_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul/1.5.0/consul_1.5.0_SHA256SUMS
  archive.extracted:
    - name: /usr/local/bin/
    - source: /tmp/consul.zip
    - user: root
    - group: root
    - enforce_toplevel: False
    - require:
      - file: stack-install-consul

/etc/consul.d/:
  file.directory:
    - user: root
    - group: root
    - mode: 0755
    - makedirs: True

stack-systemd-consul:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: salt://consul/templates/etc/systemd/system/consul.service
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: stack-systemd-consul

stack-consul-config:
  file.managed:
    - name: /etc/consul.d/config.json
    - source: salt://consul/templates/etc/consul.d/config.json
    - template: jinja

stack-consul-service-enabled:
  service.enabled:
    - name: consul

stack-consul-service-running:
  service.running:
    - name: consul
    - watch:
      - file: stack-systemd-consul
      - file: stack-consul-config


stack-install-inotify:
  pkg.installed:
    - pkgs:
      - python-inotify



