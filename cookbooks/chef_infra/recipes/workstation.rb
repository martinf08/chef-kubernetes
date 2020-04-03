apt_package 'curl'

WORKSTATION_PACKAGE = 'chefdk_4.7.73-1_amd64.deb'

directory = '/vagrant'
unless Dir.exist? directory
  directory = '/tmp'
end

FILE = "#{directory}/#{WORKSTATION_PACKAGE}"

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
    knife bootstrap "192.168.50.30" -U 'vagrant' -P 'vagrant' --sudo --use-sudo-password -N kube-master --ssh-verify-host-key 'never'
  EOH
end