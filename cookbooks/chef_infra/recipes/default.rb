apt_update 'update' do
  frequency 86400
  action :periodic
end

directory_path =  '/vagrant/cookbooks/chef_infra/files'
directory directory_path do
  mode '0755'
  recursive true
  action :create
end


hosts_list = directory_path + '/hosts.txt'
hosts = "\n" + IO.read('/etc/hosts')

file "/etc/hosts" do
  content IO.read(hosts_list).concat(hosts)
  only_if { IO.readlines('/etc/hosts').grep(/(192.168.50)/).empty? }
end

bash 'Allow ssh' do
  code <<-EOH
    sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  EOH
end

service 'ssh' do
  supports :restart => true
  action :restart
end