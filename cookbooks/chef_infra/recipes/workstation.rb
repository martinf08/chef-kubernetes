apt_package %w(curl sshpass) do
  action :install
end

WORKSTATION_PACKAGE = 'chefdk_4.7.73-1_amd64.deb'
FILE = "/tmp/#{WORKSTATION_PACKAGE}"

remote_file FILE do
  source "https://packages.chef.io/files/stable/chefdk/4.7.73/debian/9/#{WORKSTATION_PACKAGE}"
  action :create_if_missing
end

dpkg_package WORKSTATION_PACKAGE do
  source FILE
  action :install
end

bash "Configure Workstation" do
  code <<-EOH
    cd /vagrant
    chef env --chef-license=accept
    knife ssl fetch
    knife ssl check

    berks install
    berks upload --no-ssl-verify

    knife cookbook upload chef_infra --cookbook-path cookbooks
    knife cookbook upload kubernetes --cookbook-path cookbooks

    knife role from file roles/kube_master.json
    knife role from file roles/kube_node.json

    knife bootstrap "kube-master" -U 'vagrant' -P 'vagrant' --run-list 'role[kube_master]' --sudo --use-sudo-password -N kube-master --ssh-verify-host-key 'never'
    knife bootstrap "kube-node" -U 'vagrant' -P 'vagrant' --run-list 'role[kube_node]' --sudo --use-sudo-password -N kube-node --ssh-verify-host-key 'never'

    knife node run_list set kube-master 'role[kube_master]'
    knife node run_list set kube-node 'role[kube_node]'
  EOH
end

bash 'Download Kubernetes configuration' do
  code <<-EOH
    mkdir -p /home/vagrant/.kube
    sshpass -p "vagrant" rsync -arv -e 'ssh -o StrictHostKeyChecking=no' vagrant@kube-master:/home/vagrant/.kube/config /home/vagrant/.kube/config
    sudo chown vagrant:vagrant /home/vagrant/.kube/config
  EOH
end
