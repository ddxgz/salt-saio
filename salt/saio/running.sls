include:
  - saio.nodes


copy_bin:
  cmd.run:
    - user: swift
    - group: swift
    - name: mkdir /home/swift/bin;cp /home/swift/swift/doc/saio/bin/* /home/swift/bin/
    - require:
      - cmd: change_name_swift


chmod_bin:
  cmd.wait:
    - user: swift
    - group: swift
    - name: chmod +x /home/swift/bin/*
    - watch:
      - cmd: copy_bin


/home/swift/bin/resetswift:
  file.replace:
    - pattern: "/dev/sdb1"
    - repl: "/srv/swift-disk"
    - require:
      - cmd: chmod_bin
  cmd.run:
      - user: swift
      - group: swift
      - name:  echo "export SAIO_BLOCK_DEVICE=/srv/swift-disk" >> $HOME/.bashrc
      - require:
        - file: /home/swift/bin/resetswift


/etc/swift/test.conf:
  file.copy:
    - user: swift
    - group: swift
    - source: /home/swift/swift/test/sample.conf


test_env:
  cmd.run:
    - user: swift
    - group: swift
    - name:  echo "export SWIFT_TEST_CONFIG_FILE=/etc/swift/test.conf" >> $HOME/.bashrc
    - require:
      - file: /etc/swift/test.conf


path_env:
  cmd.run:
    - user: swift
    - group: swift
    - name:  echo "export PATH=${PATH}:$HOME/bin" >> $HOME/.bashrc
    - require:
      - cmd: test_env


source_env:
  cmd.run:
    - user: swift
    - group: swift
    - cwd: /home/swift
    - shell: /bin/bash
    - name:  source $HOME/.bashrc
    - require:
      - cmd: path_env


remakerings:
  cmd.run: 
    - user: swift
    - group: swift
    - name: remakerings
    - require:
      - cmd: source_env


