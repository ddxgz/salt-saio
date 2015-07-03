base:
    '*':
        - saio.user
        - saio.packages
        - saio.device
        - saio.rsync
        - saio.rsyslog
        - saio.nodes


# sdb1:
#     cmd.run:
#         - user: swift
#         - creates: /mnt/sdb1
#         - require:
#             - file: /etc/fstab

# /mnt/sdb1:
#     # cmd.run:
#     #     - user: swift
#     #     - creates: /mnt/sdb1
#     #     - require:
#     #         - file: /etc/fstab  
#     mount.mounted:
#         - device: /mnt/sdb1
#         - mkmnt: True
#         - fstype: xfs
#         - require:
#             - file: /etc/fstab  
        

/etc/rc.local:
    file.replace:
        - pattern: "exit 0"
        - repl: "mkdir -p /var/cache/swift /var/cache/swift2 /var/cache/swift3 /var/cache/swift4 \n
        chown swift:swift /var/cache/swift* \n
        mkdir -p /var/run/swift
        chown swift:swift /var/run/swift \n
        exit 0"
        - require:
            - file: copyrclocal





/mnt/sdb1/*:
    file.chown:
        - user: swift
        - group: swift
        - path: /mnt/sdb1/*
        - watch:
            - cmd: link


truncate:
    cmd.script:
        - source: salt://saio/create-disk.sh
        - name: truncate
        - user: swift
        - group: swift
        - watch:
            - pkg: common-packages
            - cmd: create-srv


mount:
    cmd.script:
        - source: salt://saio/device.sh
        - name: mount
        - user: swift
        - require:
            - cmd: create-srv
            - cmd: truncate
            - file: /etc/fstab



moutn-link:
    cmd.run:
        - user: swift
        - creates: /mnt/sdb1
    cmd.mounted:
        - user: swift
        - device: /mnt/sdb1
    cmd.wait:
        - user: swift
        - creates:
            - /mnt/sdb1/1 
            - /mnt/sdb1/2 
            - /mnt/sdb1/3 
            - /mnt/sdb1/4