#!/bin/bash

export KUBECONFIG="./$(cat ./terraform.tfvars | grep -v "#" | grep -i prefix | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')_kube_config.yml"

#kubectl -n cattle-neuvector-system delete svc neuvector-service-webui

for node in $(kubectl get nodes --no-headers | awk '{print $1}')
do
  echo "Draining $node"
  kubectl drain $node --ignore-daemonsets --force --timeout=180s
done

#https://stackoverflow.com/questions/63128973/aws-on-terraform-error-deleting-resource-timeout-while-waiting-for-state-to-be
#https://repost.aws/knowledge-center/troubleshoot-dependency-error-delete-vpc
