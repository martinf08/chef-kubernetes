apt_package 'curl'

SERVER_PACKAGE = 'chef-server-core_13.1.13-1_amd64.deb'
FILE = "/tmp/#{SERVER_PACKAGE}"

remote_file FILE do
  source "https://packages.chef.io/files/stable/chef-server/13.1.13/ubuntu/18.04/#{SERVER_PACKAGE}"
  action :create_if_missing
end

dpkg_package SERVER_PACKAGE do
  source FILE
  action :install
end

bash "Configure Chef server" do
  code <<-EOH
    chown -R vagrant:vagrant /home/vagrant
    sudo mkdir /home/vagrant/certs

    sudo chef-server-ctl reconfigure --chef-license=accept
    sudo chef-server-ctl user-create chef-workstation Chef Admin admin@domain.tld adminadmin --filename /home/vagrant/certs/client.pem
    sudo chef-server-ctl org-create cheflab "Chef Lab" --association_user chef-workstation --filename /home/vagrant/certs/validation.pem
    
    cat /home/vagrant/certs/client.pem > /vagrant/.chef/client.pem
    
    sudo chef-server-ctl install chef-manage
    sudo chef-manage-ctl reconfigure --accept-license
  EOH
  not_if { ::File.exist?('/home/vagrant/certs/client.pem') }
end