# CKA/CKS/CKAD -Lab

This repository contains the code for setting up a Lab quickly for the Certified Kubernetes exam. Its purpose is to help candidates who are stuttering for the Certified Kubernetes exam to get a lab environment up and running quickly.

This deployment sets up a CKA-Lab environment. The lab consists of 3 virtual machines (nodes): 1 control plane and 2 worker nodes. All servers are running Ubuntu 20.04 LTS which is the version used for the CKA exam as of May 2025.

All servers are connected to the same vNet. The admin password for the VMs are stored in the deployed secrets.

## Using the lab

You will need to change the parameters in the `main.parameters.json` file to match your environment.

### Setup

To set up the lab, you need to run the following commands:

```PowerShell
.\deploy.ps1 -TenantId <YOUR-TANANTID> -SubscriptionId <YOUR-SUBSCRIPTIONID>
```

Note: You will need to be logged in to Azure with the appropriate permissions.

### Connect to the servers

To connect to the lab, you can use SSH. The password for the user name 'azureadmin' are stored in the deployed secrets: 'adminPassword'.

## Install Kubernetes

### For all nodes 

```bash
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
lsmod | grep br_netfilter
sudo modprobe br_netfilter

cat << EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
sudo apt-get update && sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo swapoff -a
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet=1.32/* kubeadm=1.32/* kubectl=1.32/*
sudo apt-mark hold kubelet kubeadm kubectl
```
### Only on the control plane node

```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.32.0

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

**Check status of the cluster**
```bash 
kubectl get nodes
```
**Install Calico**

```bash 
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```
**Check status of the cluster**

```bash
kubectl get nodes
```

**Get the join command (only on the control plane node)**

```bash
kubeadm token create --print-join-command
```

**Join the worker nodes to the cluster**
```
sudo kubeadm join (get the join command from the control plane node)
remember to run the command with sudo
```

## Troubleshooting

If you encounter issues during setup, check the following:

- Ensure all VMs are in the same vNet and can communicate with each other
- Verify that the required ports are open for Kubernetes communication
- Check the Azure resource group for any deployment errors

For more help, consult the [Kubernetes documentation](https://kubernetes.io/docs/setup/).

## Keeping Up-to-Date

Kubernetes versions in the CKA exam may change. Always check the latest exam requirements and update the versions in this setup accordingly.
