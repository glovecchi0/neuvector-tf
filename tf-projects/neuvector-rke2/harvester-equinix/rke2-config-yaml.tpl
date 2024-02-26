#!/bin/bash

sudo adduser -U -m "${ssh_username}"
echo "${ssh_username}:${ssh_password}" | chpasswd
sudo sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i "s@Include /etc/ssh/sshd_config.d/\*.conf@#Include /etc/ssh/sshd_config.d/*.conf@g" /etc/ssh/sshd_config
sudo systemctl restart ssh

cat > /tmp/config.yaml <<EOF
token: ${rke2_token}
%{ if server_ip != "false" }
server: https://${server_ip}:9345
%{ endif }
%{ if rke2_config != "false" }
${rke2_config}
%{ endif }
EOF

%{ if rke2_version != "false" }
export INSTALL_RKE2_VERSION=${rke2_version}
%{ endif }
curl https://get.rke2.io | sh -
mkdir -p /etc/rancher/rke2
cp /tmp/config.yaml /etc/rancher/rke2
systemctl enable rke2-server
systemctl start rke2-server

cat > /var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx-config.yaml << EOF
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      admissionWebhooks:
        failurePolicy: Ignore
EOF

cat >> /etc/profile <<EOF
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml
PATH="$PATH:/var/lib/rancher/rke2/bin"
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
EOF

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
%{ if server_ip != "false" }
sudo helm repo add neuvector https://neuvector.github.io/neuvector-helm/
echo "kubectl create namespace cattle-neuvector-system || true" | sudo su -
echo "helm -n cattle-neuvector-system install neuvector --set k3s.enabled=true --set manager.svc.type=NodePort neuvector/core" | sudo su -
%{ endif }
