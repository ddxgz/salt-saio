create-srv:
    cmd.run:
        - user: swift
        - creates: /srv
        - name: createsrv

truncate:
    cmd.script:
        - source: salt://saio/create-disk.sh
        - name: truncate
        - user: swift
        - require:
            - cmd: create-srv

/etc/fstab:
    file.append:
        - name: /etc/fstab
        - text:
            - "/srv/swift-disk /mnt/sdb1 xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0"


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