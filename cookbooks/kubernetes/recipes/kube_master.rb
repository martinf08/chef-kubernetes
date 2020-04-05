ruby_block "Kubeadm init" do
  block do
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
    command = "sudo kubeadm init --apiserver-advertise-address=#{node["network"]["interfaces"]["eth1"]} --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all"
    command_out = shell_out(command)
    node.default['token'] = command_out.stdout

    # Join command
    node.default['token'] = node.default['token'].scan(/kubeadm join .* | --discovery-token-ca-cert-hash .*/i)
    node.default['token'] = 'sudo ' + node.default['token'].map(&:strip).join(' ') + ' --ignore-preflight-errors=all'

    IO.write("/vagrant/test.txt",  node.default['token'])
  end
  action :create

  not_if { ::File.exist?('/etc/kubernetes/manifests/kube-apiserver.yaml') }
end

bash 'Copy Kubernetes configuration' do
  code <<-EOH
    mkdir -p #{ENV['HOME']}/.kube
    sudo cp /etc/kubernetes/admin.conf #{ENV['HOME']}/.kube/config
    sudo chown vagrant:vagrant #{ENV['HOME']}/.kube/config
  EOH
end

bash 'Deploy pod network' do
  code <<-EOH
    sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  EOH
end