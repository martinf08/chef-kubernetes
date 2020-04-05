directory "/vagrant/cookbooks/kubernetes/files/" do
  mode '0755'
  recursive true
  action :create
end

ruby_block "Kubeadm init" do
  block do
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
    command = "sudo kubeadm init --apiserver-advertise-address=192.168.50.30 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all"
    command_out = shell_out(command)

    # Join command
    join = command_out.stdout.scan(/kubeadm join .* | --discovery-token-ca-cert-hash .*/i)
    join = 'sudo ' + join.map(&:strip).join(' ') + ' --ignore-preflight-errors=all'

    IO.write('/vagrant/cookbooks/kubernetes/files/join_command.txt',  join)
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