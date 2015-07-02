include:
    - saio.rsyslog


rm_etc/swift:
    cmd.run:
        - user: swift
        - group: swift
        - name: sudo rm -rf /etc/swift
        - require:
            - service: rsyslog


copy_swift_conf:
    cmd.run:
        - user: swift
        - group: swift
        - name: sudo cp -r /home/swift/swift/doc/saio/swift /etc/
        - require:
            - cmd: rm_etc/swift


chown_etc/swift:
    cmd.run:
        - user: swift
        - group: swift
        - name: sudo chown -R ${USER}:${USER} /etc/swift
        - require:
            - cmd: copy_swift_conf


change_name_swift:
    cmd.run:
        - user: swift
        - group: swift
        - name: find /etc/swift/ -name \*.conf | xargs sudo sed -i "s/<your-user-name>/${USER}/"
        - require:
            - cmd: chown_etc/swift

