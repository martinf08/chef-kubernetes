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
  not_if { node['packages'].keys.include? "kubeadm" }
end

apt_package 'kubeadm' do
  action :install
end

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
