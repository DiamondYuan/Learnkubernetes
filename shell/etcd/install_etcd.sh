command_exists() {
	command -v "$@" >/dev/null 2>&1
}
if command_exists etcdctl && command_exists etcd; then
	echo 存在
else
	wget https://github.com/coreos/etcd/releases/download/v3.2.10/etcd-v3.2.10-linux-amd64.tar.gz && \
	tar -xvf etcd-v3.2.10-linux-amd64.tar.gz && \
	mv etcd-v3.2.10-linux-amd64/etcd* /usr/local/bin && \
	rm -rf etcd-v3.2.10-linux-amd64 etcd-v3.2.10-linux-amd64.tar.gz
    echo 下载成功
fi
exit 0
