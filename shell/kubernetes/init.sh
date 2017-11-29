read -p "请输入当前服务器IP : " nodeIp
read -p "请输入ETCD的IP （ https://xxx.xxx.xxx.xxx:2379,https://xxx.xxx.xxx.xxx:2379 ) : " etcd

bash install_kubernets.sh
bash kube_mater_config.sh $nodeIp $etcd
bash kube_mater.sh