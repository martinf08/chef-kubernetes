apt_update 'update' do
  frequency 86400
  action :periodic
end

guest_hosts_path = Chef::Config[:cookbook_path] + '/chef_infra/files/hosts.txt'
hosts = "\n" + IO.read('/etc/hosts')

file "/etc/hosts" do
  content IO.read(guest_hosts_path).concat(hosts)
  only_if { IO.readlines('/etc/hosts').grep(/(192.168.50)/).empty? }
end