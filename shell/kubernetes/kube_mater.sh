#配置启动kube-apiserver
cat > /etc/systemd/system/kube-apiserver.service <<EOF
[Unit]
Description=Kubernetes API Service
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
After=etcd.service
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/apiserver
ExecStart=/usr/local/bin/kube-apiserver \
        ${KUBE_LOGTOSTDERR} \
        ${KUBE_LOG_LEVEL} \
        ${KUBE_ETCD_SERVERS} \
        ${KUBE_API_ADDRESS} \
        ${KUBE_API_PORT} \
        ${KUBELET_PORT} \
        ${KUBE_ALLOW_PRIV} \
        ${KUBE_SERVICE_ADDRESSES} \
        ${KUBE_ADMISSION_CONTROL} \
        ${KUBE_API_ARGS}
Restart=on-failure
Type=notify
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF
## 启动kube-apiserver
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver

#配置和启动 kube-controller-manager
export KUBE_CONTROLLER_MANAGER_ARGS="--address=127.0.0.1 --service-cluster-ip-range=${serviceClusterIpRange} --cluster-name=kubernetes --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem --cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem  --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem --root-ca-file=/etc/kubernetes/ssl/ca.pem --leader-elect=true"

cat > /etc/systemd/system/kube-controller-manager.service <<EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/controller-manager
ExecStart=/usr/local/bin/kube-controller-manager \
        ${KUBE_LOGTOSTDERR} \
        ${KUBE_LOG_LEVEL} \
        ${KUBE_MASTER} \
        ${KUBE_CONTROLLER_MANAGER_ARGS}
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

## 启动 kube-controller-manager
systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager

#配置和启动 kube-scheduler
export KUBE_SCHEDULER_ARGS="--leader-elect=true --address=127.0.0.1"

cat > /etc/systemd/system/kube-scheduler.service <<EOF
[Unit]
Description=Kubernetes Scheduler Plugin
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/scheduler
ExecStart=/usr/local/bin/kube-scheduler \
            ${KUBE_LOGTOSTDERR} \
            ${KUBE_LOG_LEVEL} \
            ${KUBE_MASTER} \
            ${KUBE_SCHEDULER_ARGS}
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

## 启动 kube-scheduler
systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler