name=$1;
node=$2;
initial_cluster=$3
echo 当前服务器名字：$name 当前服务器IP：$node
cat > etcd.conf <<EOF
# [member]
ETCD_NAME=$name
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_LISTEN_PEER_URLS="https://$node:2380"
ETCD_LISTEN_CLIENT_URLS="https://$node:2379"

#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://$node:2380"
ETCD_INITIAL_CLUSTER=$initial_cluster
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="https://$node:2379"
EOF
mv etcd.conf /etc/etcd/etcd.conf