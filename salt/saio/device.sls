include:
    - saio.user
    - saio.packages

create-srv:
    cmd.run:
        - user: swift
        - group: swift
        - creates: /srv
        - name: createsrv
        - require:
            - user: swift

# truncate:
#     cmd.script:
#         - source: salt://saio/create-disk.sh
#         - name: truncate
#         - user: swift
#         - group: swift
#         - watch:
#             - pkg: common-packages
#             - cmd: create-srv


truncate:
    cmd.run:
        - name: sudo truncate -s 1GB /srv/swift-disk
        - user: swift
        - group: swift
        - require:
            - pkg: common-packages
            - cmd: create-srv


mkfs:
    cmd.wait:
        - name: sudo mkfs.xfs /srv/swift-disk
        - user: swift
        - group: swift
        - watch:
            - cmd: truncate


# /etc/fstab:
#     file.append:
#         - name: /etc/fstab
#         - text:
#             - "/srv/swift-disk /mnt/sdb1 xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0"
#         - require:
#             - cmd: mkfs


# /mnt/sdb1:
#     cmd.wait:
#         - user: swift
#         - group: swift
#         - name: sudo mkdir /mnt/sdb1;sudo mount /mnt/sdb1
#         - watch:
#             - file: /etc/fstab  


/mnt/sdb1:
    mount.mounted:
        - device: /srv/swift-disk
        - mkmnt: True
        - fstype: xfs
        - opts: nobootwait,noatime,nodiratime,nobarrier,logbufs=8
        - dump: 0
        - pass_num: 0
        - require:
            - cmd: mkfs


{% for i in ['1', '2', '3', '4'] %}
/mnt/sdb1/{{i}}:
    file.directory:
        - user: swift
        - group: swift
        - makedirs: True
{% endfor %}


{% for i in ['1', '2', '3', '4'] %}
/srv/{{i}}:
    file.symlink:
        - target: /mnt/sdb1/{{i}}
        - force: True
        - require:
            - file: /mnt/sdb1/{{i}}
{% endfor %}


{% for i in [1,2,3,4,5,6,7,8] %}
{% if i<5 %}
/srv/{{i}}/node/sdb{{i}}:
    file.directory:
        - user: swift
        - group: swift
        - makedirs: True
{% else %}
/srv/{{i-4}}/node/sdb{{i}}:
    file.directory:
        - user: swift
        - group: swift
        - makedirs: True
{% endif %}
{% endfor %}


/var/run/swift:
    file.directory:
        - user: swift
        - group: swift
        - makedirs: True

/etc/rc.local.bk:
    file.copy:
        - source: /etc/rc.local

/etc/rc.local:
    file.replace:
        - pattern: "exit 0"
        - repl: "mkdir -p /var/cache/swift /var/cache/swift2 /var/cache/swift3 /var/cache/swift4 \nchown swift:swift /var/cache/swift* \nmkdir -p /var/run/swift \nchown swift:swift /var/run/swift \nexit 0"
        - require:
            - file: /etc/rc.local.bk


https://github.com/openstack/python-swiftclient.git:
    git.latest:
        - user: swift
        - rev: stable/kilo
        - target: /home/swift/python-swiftclient

requirements-swiftclient:
    cmd.run:
        - user: swift
        - group: swift
        - cwd: /home/swift/python-swiftclient
        - name: sudo pip install -r requirements.txt
        - require:
            - git: https://github.com/openstack/python-swiftclient.git

setup-swiftclient:
    cmd.run:
        - user: swift
        - group: swift
        - cwd: /home/swift/python-swiftclient
        - name: sudo python setup.py develop
        - require:
            - cmd: requirements-swiftclient


https://github.com/openstack/swift.git:
    git.latest:
        - user: swift
        - rev: stable/kilo
        - target: /home/swift/swift

requirements-swift:
    cmd.run:
        - user: swift
        - group: swift
        - cwd: /home/swift/swift
        - name: sudo pip install -r requirements.txt
        - require:
            - git: https://github.com/openstack/swift.git

setup-swift:
    cmd.run:
        - user: swift
        - group: swift
        - cwd: /home/swift/swift
        - name: sudo python setup.py develop
        - require:
            - cmd: requirements-swift

requirements-test:
    cmd.run:
        - user: swift
        - group: swift
        - cwd: /home/swift/swift
        - name: sudo pip install -r test-requirements.txt
        - require:
            - cmd: setup-swift