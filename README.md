Salt-Swift
====

Use SaltStack to install Swift-All-In-One.

Currently only works for Ubuntu 12.04 or above.

> Notice: This salt installs SAIO to the step 'remakerings', the rest is need to do by yourself.

There are two ways here to install saio with saltstack:
- Normal way
- Vagrant

Normal way
----
1. Install salt-minion on the node you want to install Swift on

  ```
  wget -O - http://bootstrap.saltstack.org | sudo sh

  ```

  If there is any problem with the network connection, use bootstrap-salt.sh instead.

2. Edit /etc/salt/minion, set master ip to the node that you  want to use as a master, and set id to the name you want to call the swift node, like 'minion1'

  ```
  master: 10.200.*.*
  id: minion1
  ```

3. Start the minion

  ```
  sudo service salt-minion start|restart
  ```

4. Install salt-master on the node you want to control the installation, it can also be on the same node as minion

  ```
  curl -L http://bootstrap.saltstack.org | sudo sh -s -- -M -N
  ```

5. Edit /etc/salt/master, add file_roots to /path/to/top.sls, like

  ```
  file_roots:
    base:
      - /home/pc/saio-setup/salt
  ```

6. Start the master

  ```
  sudo service salt-master start|restart
  ```

7. Accept minion's pub key

  ```
  sudo salt-key -a minion1
  sudo salt minion1 test.ping
  ```

  If test.ping returns 'True', congratulations!

8. Copy the ./salt to master, go to saio-setup/salt/, edit the 'top.sls' file, and change the minion name to the one you set (in this case is minion1), like:

  ```
  base:
      'minion1':
          - saio.user
          - saio.packages
          - saio.device
          - saio.rsync
          - saio.rsyslog
          - saio.nodes
          - saio.running
  ```
  or you can just set the 'minion1' to '*' to match all the minion nodes.

  Since this installation will create a user and group 'swift:swift', so it needs to confirm that there are not existed uid and gid the same to the ones in 'user.sls'. Otherwise, you need to change the uid and gid in 'user.sls':
  ```
  swift:
    user.present:
        ......
        - uid: 1001
        - gid: 1001
        ......
    group.present:
        - gid: 1001
        ......
  ```

9. Copy the ./salt to master, go to salt/ (where top.sls is) and run salt:

  ```
  sudo salt minion1 state.highstate
  ```
  Sometimes there will be errors or warmings, run salt again might get errors away, if the error info tells you that the problem is related to PyECLib, then you need to install its pre-requisites, please see: https://bitbucket.org/kmgreen2/pyeclib or http://docs.openstack.org/developer/swift/overview_erasure_code.html#pyeclib-external-erasure-code-library  

Vagrant
----
todo...


SAIO install procedure
----
1. Add user for swift
2. Install packages
3. Set device
4. Get code and install
5. Config rsync
6. Start memcached
7. Set up rsyslog
8. Config each node
9. Stup up scripts and makerings
