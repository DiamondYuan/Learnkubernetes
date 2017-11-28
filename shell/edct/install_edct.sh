wget https://github.com/coreos/etcd/releases/download/v3.2.10/etcd-v3.2.10-linux-amd64.tar.gz
tar -xvf etcd-v3.2.10-linux-amd64.tar.gz
mv etcd-v3.2.10-linux-amd64/etcd* /usr/local/bin
rm -rf etcd-v3.2.10-linux-amd64 etcd-v3.2.10-linux-amd64.tar.gz