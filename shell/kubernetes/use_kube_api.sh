command_exists() {
	command -v "$@" >/dev/null 2>&1
}
if command_exists kube-apiserver &&
	command_exists kube-controller-manager &&
	command_exists kube-scheduler &&
	command_exists kube-proxy &&
	command_exists kubelet &&
	command_exists kubectl; then
	echo 存在
else
	wget https://dl.k8s.io/v1.8.4/kubernetes-server-linux-amd64.tar.gz &&
		tar -xzvf kubernetes-server-linux-amd64.tar.gz &&
		cd kubernetes &&
		tar -xzvf kubernetes-src.tar.gz &&
		cp -r server/bin/{kube-apiserver,kube-controller-manager,kube-scheduler,kubectl,kube-proxy,kubelet} /usr/local/bin/
fi
exit 0
