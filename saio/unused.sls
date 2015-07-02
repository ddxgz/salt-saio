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