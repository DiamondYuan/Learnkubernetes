node_ip=$1
etcd_servers=$2

cat >/etc/kubernetes/config <<EOF
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_LEVEL="--v=0"
KUBE_ALLOW_PRIV="--allow-privileged=true"
KUBE_MASTER="--master=http://$node_ip:8080"
EOF

cat >/etc/kubernetes/apiserver <<EOF
KUBE_API_ADDRESS="--advertise-address=$node_ip --bind-address=$node_ip --insecure-bind-address=$node_ip"
KUBE_ETCD_SERVERS="--etcd-servers=$etcd_servers"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_ADMISSION_CONTROL="--admission-control=ServiceAccount,NamespaceLifecycle,NamespaceExists,LimitRanger,ResourceQuota"
KUBE_API_ARGS="--authorization-mode=RBAC --runtime-config=rbac.authorization.k8s.io/v1beta1 \
--kubelet-https=true --experimental-bootstrap-token-auth --token-auth-file=/etc/kubernetes/token.csv \
--service-node-port-range=30000-32767 --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem \
--tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem --client-ca-file=/etc/kubernetes/ssl/ca.pem \
--service-account-key-file=/etc/kubernetes/ssl/ca-key.pem --etcd-cafile=/etc/kubernetes/ssl/ca.pem \
--etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem --etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem \
--enable-swagger-ui=true --apiserver-count=3 --audit-log-maxage=30 --audit-log-maxbackup=3 --audit-log-maxsize=100 \
--audit-log-path=/var/lib/audit.log --event-ttl=1h"
EOF

cat >/etc/kubernetes/scheduler <<EOF
KUBE_SCHEDULER_ARGS="--leader-elect=true --address=127.0.0.1"
EOF

cat >/etc/kubernetes/controller-manager <<EOF
KUBE_CONTROLLER_MANAGER_ARGS="--address=127.0.0.1 --service-cluster-ip-range=10.254.0.0/16 \
--cluster-name=kubernetes --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem \
--cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem  --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem \
--root-ca-file=/etc/kubernetes/ssl/ca.pem --leader-elect=true"
EOF
