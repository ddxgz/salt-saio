include:
    - saio.device


/etc/rsyncd.conf:
    file.copy:
        - user: swift
        - group: swift
        - source: /home/swift/swift/doc/saio/rsyncd.conf
        - require:
            - cmd: requirements-test


rsyncuser:
    file.replace:
        - name: /etc/rsyncd.conf
        - pattern: "<your-user-name>"
        - repl: "swift"


enablersync:
    file.replace:
        - name: /etc/default/rsync
        - pattern: "RSYNC_ENABLE=false"
        - repl: "RSYNC_ENABLE=true"
        - require:
            - file: rsyncuser

rsync:
    service.running:
    - enable: True
    - reload: True
    - watch:
      - file: enablersync


memcached:
    service.running:
    - enable: True
    - reload: True
    - watch:
      - file: enablersync