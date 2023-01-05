![CI Pipeline](https://github.com/nikitabugrovsky/ansible-lab/actions/workflows/ci.yml/badge.svg)

# ansible-lab
Ansible Lab: 3 nodes setup: control node (ansible installed) + 2 workers in Vagrant (Rocky Linux 9 box).
Current setup supports 2 vagrant providers:
- [virtualbox](https://developer.hashicorp.com/vagrant/docs/providers/virtualbox)
- [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

# Releases

| Release                                                                                        	| Description                                                          	|
|------------------------------------------------------------------------------------------------	|----------------------------------------------------------------------	|
| [Rocky Linux 9 Box Complete](https://github.com/nikitabugrovsky/ansible-lab/releases/tag/v2.0) 	| Latest Rocky Linux box release. Requires 1 GB RAM & 1 vCPU per node. 	|
| [CentOS 7 Box Complete](https://github.com/nikitabugrovsky/ansible-lab/releases/tag/v1.0)      	| Older CentOS 7 box release. Requires 256 MB RAM & 1 vCPU per node.   	|

# Requirements

1. Supported Host OS:
  - Linux
  - MacOS
  - Windows
2. Vagrant >= 2.1.5 (latest tested 2.2.19)
3. VirtualBox >= 5.2.18
4. (alternatively) libvirt (QEMU/KVM) = 8.6.0-5.fc37
5. Supported Guest OS: rockylinux/9 box (CentOS successor)

# Prerequisites

## libvirt provider (Fedora 37)

```
sudo dnf install @virtualization vagrant vagrant-libvirt vagrant-sshfs vagrant-hosts vagrant-cachier
```

# Start Lab

```bash
vagrant up
```

# Run ansible provisioning from control-node

```bash
vagrant ssh control-node -c  "ansible-playbook /vagrant/provisioning/ansible/playbook.yml"
```

# Destroy lab

```
vagrant destroy
```
