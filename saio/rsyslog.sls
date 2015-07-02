include:
    - saio.rsync


/etc/rsyslog.d/10-swift.conf:
    file.copy:
        - user: swift
        - group: swift
        - source: /home/swift/swift/doc/saio/rsyslog.d/10-swift.conf
        - require:
            - service: rsync


/etc/rsyslog.conf:
    file.replace:
        - name: /etc/rsyslog.conf
        - pattern: "$PrivDropToGroup syslog"
        - repl: "$PrivDropToGroup adm"


/var/log/swift:
    file.directory:
        - user: swift
        - group: swift
        - makedirs: True


chown_rsyslog:
    cmd.run:
        - user: swift
        - group: swift
        - name: sudo chown -R syslog.adm /var/log/swift
        - require:
            - file: /var/log/swift


chmod_rsyslog:
    cmd.wait:
        - user: swift
        - group: swift
        - name: sudo chmod -R g+w /var/log/swift
        - watch:
            - cmd: chown_rsyslog


rsyslog:
    service.running:
        - enable: True
        - reload: True
        - watch:
          - cmd: chmod_rsyslog

