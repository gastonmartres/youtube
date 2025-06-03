#!/bin/bash
echo "[ Installing RKE2 Server]"
ansible-playbook playbook.yml -i inventory -l rke2_server
echo "[ Installing RKE2 Nodes]"
ansible-playbook playbook.yml -i inventory -l rke2_node
echo "[ Installing RKE2 Workers]"
ansible-playbook playbook.yml -i inventory -l rke2_agent
echo "[ Installing NFS Server]"
ansible-playbook playbook.yml -i inventory -l nfs_server
