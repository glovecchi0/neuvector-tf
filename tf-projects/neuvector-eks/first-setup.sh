#!/bin/bash

# Backup the KUBECONFIG file
#cp "./$(cat ./terraform.tfvars | grep -v "#" | grep -i prefix | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')_kube_config.yml" "./$(cat ./terraform.tfvars | grep -v "#" | grep -i prefix | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')_kube_config.yml.backup"

export KUBECONFIG="./$(cat ./terraform.tfvars | grep -v "#" | grep -i prefix | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')_kube_config.yml" 

kubectl config view

# Add Kubernetes labels
j=0
for i in $(kubectl get nodes --no-headers | awk '{print $1}')
do
  if [[ $j < 3 ]] #Dedicate only the first 3 nodes to NeuVector
  then 
    kubectl label node $i node-role.kubernetes.io/nvcontroller=""
  fi
  kubectl label node $i node-role.kubernetes.io/worker=""
  j=($j + 1)
done
