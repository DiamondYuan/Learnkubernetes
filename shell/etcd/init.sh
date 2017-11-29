#!/bin/bash
echo 请输入服务器IP列表 用空格隔开 回车结束
read -a nodes
echo 请输入服务器名字 用空格隔开 回车结束
read -a names

initial_cluster=""
for ((i = 0; i < ${#nodes[@]}; ++i)); do
	initial_cluster=${initial_cluster}${names[i]}=https://${nodes[i]}:2380,
	printf "服务器%s IP：%s 名字： %s\n" "$i" "${nodes[i]}" "${names[i]}"
done
initial_cluster=${initial_cluster%?}
read -p "请输入当前服务器索引 : " index
echo 集群配置: $initial_cluster
echo 当前服务器IP：${nodes[$index]} 当前服务器名字：${names[$index]}

read -r -p "Are you sure? [y/N] :" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
	if [ ! -d "/var/lib/etcd" ]; then
		mkdir /var/lib/etcd
	fi

	if [ ! -d "/etc/etcd" ]; then
		mkdir /etc/etcd
	fi

	bash install_etcd.sh
	bash etcd_config.sh ${names[$index]} ${nodes[$index]} ${initial_cluster}

else

	echo 你自己取消了任务
	exit 0
fi
