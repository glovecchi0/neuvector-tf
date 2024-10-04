# How to create resources

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_name` to identify the project in your Equinix account <- **otherwise you can export the `TF_VAR_project_name` or `TF_VAR_project_id` variable**
    -  `metro` to suit your Region
    -  `api_key` to access your Equinix account <- **otherwise you can export the `METAL_AUTH_TOKEN` or `TF_VAR_api_key` variable**
    -  `vm_namespace` to specify the namespace where the VMs will be placed
    -  `ssh_password` to specify the password used for SSH login to Harvester's Virtual Machines
- Make sure you are logged into your Equinix Account from your local Terminal. See the preparatory steps [here](../../../tf-modules/harvester/infrastructure/README.md).

#### Optionally the user can also provide:

`TF_VAR_metal_create_project` Terraform variable to create a project of name `TF_VAR_project_name` if it does not exist.

#### Terraform Apply (Infrastructure only)
```bash
terraform init -upgrade && terraform apply -auto-approve
```

#### Terraform Apply (Infrastructure + Virtual Machines)
```bash
terraform init -upgrade && terraform apply -auto-approve && sed -i '' 's|/\*|#/\*|g; s|\*/|#\*/|g' main.tf outputs.tf && terraform init -upgrade && terraform apply -auto-approve
```

#### Terraform Destroy (Infrastructure only)
```bash
terraform destroy -auto-approve
```

#### Terraform Destroy (Infrastructure + Virtual Machines)
```bash
terraform destroy -auto-approve && sed -i '' 's/#//g' main.tf outputs.tf
```

#### OpenTofu Apply (Infrastructure only)
```bash
tofu init -upgrade && tofu apply -auto-approve
```

#### OpenTofu Apply (Infrastructure + Virtual Machines)
```bash
tofu init -upgrade && tofu apply -auto-approve && sed -i '' 's|/\*|#/\*|g; s|\*/|#\*/|g' main.tf outputs.tf && tofu init -upgrade && tofu apply -auto-approve
```

#### OpenTofu Destroy (Infrastructure only)
```bash
tofu destroy -auto-approve
```

#### OpenTofu Destroy (Infrastructure + Virtual Machines)
```bash
tofu destroy -auto-approve && sed -i '' 's/#//g' main.tf outputs.tf
```

## How to access Equinix instances

#### Add your PUBLIC SSH Key to your Equinix profile (Click at the top right > My Profile > SSH Keys > + Add New Key)

#### Run the following command

```bash
ssh -oStrictHostKeyChecking=no -i <PREFIX>-ssh_private_key.pem rancher@<PUBLIC_IPV4>
```

## How to access Harvester VMs

#### Install virtctl

##### macOS installation and setup

```bash
export VERSION=v0.54.0
wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-darwin-amd64
mv virtctl-v0.54.0-darwin-amd64 virtctl
chmod +x virtctl
sudo mv virtctl /usr/local/bin/
virtctl version
```

#### Run the following command

```bash
export KUBECONFIG=<PREFIX>_kube_config.yml
kubectl -n <VM_NAMESPACE> get vmi
virtctl ssh --local-ssh=true <SSH_USERNAME>@vmi/<VM_NAME>.<VM_NAMESPACE>
```

## How to access NeuVector UI

#### Create a service that forwards a designated port of a VM (neuvector-service-webui svc port) and expose the service on the specified port of the node (Harvester Equinix instance)

##### Get the NodePort port assigned to the neuvector-service-webui service and the name of the VM on which the NeuVector Manager pod has been deployed

```bash
export KUBECONFIG=<PREFIX>_kube_config.yml
kubectl -n <VM_NAMESPACE> get vmi
virtctl ssh --local-ssh=true <SSH_USERNAME>@vmi/<VM_NAME>.<VM_NAMESPACE>
kubectl -n cattle-neuvector-system get pods -l app=neuvector-manager-pod -owide #NODE_NAME
kubectl -n cattle-neuvector-system get svc neuvector-service-webui -owide #NODE_PORT
```

##### Use the outputs of the commands executed in the previous step to forward the service
```bash
virtctl -n <VM_NAMESPACE> expose vm NODE_NAME --name neuvector-console --type NodePort --port NODE_PORT
```

##### Get the port assigned to your new NodePort service and connect to NeuVector UI
```bash
kubectl -n <VM_NAMESPACE> get svc
nc -v -w1 INSTANCE_PUBLIC_IP NODE_PORT #TEST
```

##### EXAMPLE
```bash
$ export KUBECONFIG=demo_kube_config.yml

$ k -n demo-ns get vmi
NAME             AGE    PHASE     IP           NODENAME READY
demo-vm-1-umbm   119m   Running   10.52.3.20   demo-2   True
demo-vm-1-zimv   119m   Running   10.52.0.78   demo-1   True
demo-vm-2-umbm   119m   Running   10.52.3.21   demo-2   True

$ virtctl ssh --local-ssh=true ubuntu@vmi/demo-vm-1-umbm.demo-ns
...
...
...
> ubuntu@demo-vm-1-umbm:~$ sudo su -
> root@demo-vm-1-umbm:~# kubectl -n cattle-neuvector-system get pods -l app=neuvector-manager-pod -owide
NAME                                     READY   STATUS    RESTARTS   AGE   IP          NODE             NOMINATED NODE   READINESS GATES
neuvector-manager-pod-77f6954bc6-zv54g   1/1     Running   0          44m   10.42.2.7   demo-vm-1-umbm   <none>           <none>
root@demo-vm-1-umbm:~# kubectl -n cattle-neuvector-system get svc neuvector-service-webui -owide 
NAME                      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
neuvector-service-webui   NodePort   10.43.137.104   <none>        8443:32375/TCP   44m   app=neuvector-manager-pod
root@demo-vm-1-umbm:~# exit
ubuntu@demo-vm-1-umbm:~$ exit

$ virtctl -n demo-ns expose vm demo-vm-1-umbm --name neuvector-console --type NodePort --port 32375
Service neuvector-console successfully exposed for vm demo-vm-1-umbm

$ k -n demo-ns get svc
NAME                TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
neuvector-console   NodePort   10.53.217.248   <none>        32375:31496/TCP   54s
$ nc -v -w1 demo-2-PUBLIC-IP 31496 #NeuVector's Console: neuvector-manager-pod-77f6954bc6-zv54g | Harvester's VM: demo-vm-1-umbm | Equinix's Node: demo-2
Connection to demo-2-PUBLIC-IP port 31496 [tcp/*] succeeded!
```
