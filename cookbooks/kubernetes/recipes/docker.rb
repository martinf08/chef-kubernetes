# Docker

group 'docker' do
  action :create
end

user 'vagrant' do
  group 'docker'
  system true
  shell '/bin/bash'
  action :create
end

apt_repository 'docker' do
  uri "https://download.docker.com/linux/#{node['platform']}/"
  components ['stable']
  distribution node['lsb']['codename']
  key "https://download.docker.com/linux/#{node['platform']}/gpg"
  action :add
  deb_src true
end

apt_update 'update' do
  action :update
end

package %w(docker-ce docker-ce-cli containerd.io)

user 'vagrant' do
  gid 'docker'
  action :manage
end

service 'docker' do
  action :enable
  action :start
end