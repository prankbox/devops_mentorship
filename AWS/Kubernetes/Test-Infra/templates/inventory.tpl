[all]
${connection_strings_master}
${connection_strings_node}
${connection_strings_etcd}
${public_ip_address_bastion}

[bastion]
${public_ip_address_bastion}

[kube_control_plane]
${list_master}

[kube_control_plane:vars]
ansible_user = admin
ansible_ssh_private_key_file = ~/.ssh/aws_rsa
ansible_ssh_common_args = "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\"ssh admin@${bastion_ip} -i ~/.ssh/aws_rsa -W %h:%p\""

[kube_node]
${list_node}

[kube_node:vars]
ansible_user = admin
ansible_ssh_private_key_file = ~/.ssh/aws_rsa
ansible_ssh_common_args = "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\"ssh admin@${bastion_ip} -i ~/.ssh/aws_rsa -W %h:%p\""

[etcd]
${list_etcd}

[calico_rr]

[k8s_cluster:children]
kube_node
kube_control_plane
calico_rr

[k8s_cluster:vars]
${nlb_api_fqdn}
