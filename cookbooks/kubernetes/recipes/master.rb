apt_repository 'kubernetes' do
  uri "http://apt.kubernetes.io/"
  components ['main']
  distribution 'kubernetes-xenial'
  key "https://packages.cloud.google.com/apt/doc/apt-key.gpg"
  action :add
  deb_src true
end

apt_update 'Update repository' do
  action :update
end

apt_package 'kubeadm'

contents = []
IO.foreach('/etc/fstab') do |line|
  if line !~ /swap/
    contents << line
  end
end

file "/etc/fstab" do
  content contents.join("")
  not_if { IO.readlines('/etc/hosts').grep(/swap/).empty? }
end

bash "Kubeadm init" do
  code <<-EOH
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all
  EOH
end

ruby_block "Kubeadm init" do
  block do
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
    command = 'sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all'
    command_out = shell_out(command)
    node.default['token'] = command_out.stdout

    # Join command
    node.default['token'] = node.default['token'].scan(/kubeadm join .* | --discovery-token-ca-cert-hash .*/i)
    node.default['token'] = 'sudo ' + node.default['token'].map(&:strip).join(' ') + ' --preflight-errors=all'

    IO.write("/vagrant/test.txt",  node.default['token'])

  end
  action :create
end
