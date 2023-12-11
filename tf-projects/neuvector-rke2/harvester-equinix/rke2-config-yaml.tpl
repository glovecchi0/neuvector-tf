#!/bin/bash

sudo systemctl stop ufw.service
sudo systemctl disable ufw.service

export SSH_USER="${ssh_username}"
export SSH_PASS="${ssh_password}"

sudo adduser -U -m $NEW_USER
echo "$SSH_USER:$SSH_PASS" | chpasswd
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo systemctl restart ssh

PUBLIC_IP=$(curl ifconfig.io)

cat > /tmp/config.yaml <<EOF
token: ${rke2_token}
%{ if server_ip != "false" }
server: https://${server_ip}:9345
%{ endif }
#node-external-ip: $PUBLIC_IP
#tls-san:
#  - "$PUBLIC_IP"
#  - "$PUBLIC_IP.sslip.io"
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
