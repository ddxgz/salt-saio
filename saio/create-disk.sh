sudo rm -rf /srv/swift-disk
sudo truncate -s 1GB /srv/swift-disk
sudo mkfs.xfs /srv/swift-disk