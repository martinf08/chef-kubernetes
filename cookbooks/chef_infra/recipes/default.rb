apt_update 'update' do
  frequency 86400
  action :periodic
end

hosts = IO.read('/etc/hosts')
file "/etc/hosts" do
  content hosts.concat(JSON.parse(node[:hosts]).join(''))
  only_if { IO.readlines('/etc/hosts').grep(/(192.168.50)/).empty? }
end

bash 'Allow ssh' do
  code <<-EOH
    sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  EOH
end

service 'ssh' do
  supports :restart => true
  action :restart
end