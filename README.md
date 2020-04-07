# chef-kubernetes

Deploy chef infra and kubernetes cluster using vagrant provider

## Prerequises
Install [Vagrant] and [VirtualBox].

- https://www.vagrantup.com/downloads.html
- https://www.virtualbox.org/wiki/Downloads

### Versions
- Vagrant ![version](https://img.shields.io/badge/version-2.2.7-blue)
- Virtualbox ![version](https://img.shields.io/badge/version-6.1-blue)

## Usage

### Deploy infra
<code>vagrant up</code>

And wait installing system

### Connect to the chef-workstation to drive infrastructure
<code>vagrant ssh chef-workstation</code>

### View chef node status
<pre>
cd /vagrant
knife status
</pre>
![knife_status](https://user-images.githubusercontent.com/39262279/78640741-85a54700-78b0-11ea-9e1b-333f0c690dae.png)

### View kubernetes node status
<pre>kubectl get node</pre>
![kubectl_get_node](https://user-images.githubusercontent.com/39262279/78640769-95249000-78b0-11ea-948d-26e827555086.png)

### Connect to chef server
#### Link
https://192.168.50.10/

#### Credentials

user: chef-workstation

password: adminadmin

![chef-server](https://user-images.githubusercontent.com/39262279/78641371-7246ab80-78b1-11ea-92a2-360c157e6574.png)
