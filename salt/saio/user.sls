swift:
    user.present:
        - fullname: swift
        - shell: /bin/bash
        - home: /home/swift
        - uid: 1001
        - gid: 1001
        - groups:
            - root
            - swift
        - require:
            - group: swift
    group.present:
        - gid: 1001
        - name: swift

/etc/sudoers:
    file.append:
        - text:
            - "swift ALL=(ALL) NOPASSWD:ALL"


