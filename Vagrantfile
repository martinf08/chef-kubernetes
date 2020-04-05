require_relative 'src/VmsModule'

VmsModule.write_host_file

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  #config.vagrant.plugins = %w(vagrant-vbguest vagrant-hostsupdater)

  VmsModule.get_instances.each do |instance|

    config.vm.define instance.name do |current|

      if instance.need_synced_folder?
        current.vm.synced_folder '.', '/vagrant', type: 'virtualbox'
      end

      current.vm.provider "virtualbox" do |vb|
        vb.cpus = instance.cpu
        vb.memory = instance.mem
      end

      current.vm.box = instance.image_name
      current.vm.hostname = instance.name
      current.vm.network 'private_network', ip: "#{instance.ip}"

      if instance.type == VirtualMachine::TYPE_CHEF_SERVER

        current.vm.provision "chef_solo" do |chef|
          chef.arguments = "--chef-license accept"

          chef.add_recipe "recipe[chef_infra::default]"
          chef.add_recipe "recipe[chef_infra::server]"
        end

      end

      if instance.type == VirtualMachine::TYPE_CHEF_WORKSTATION

        current.vm.provision "chef_solo" do |chef|
          chef.arguments = "--chef-license accept"

          chef.add_recipe "recipe[chef_infra::default]"
          chef.add_recipe "recipe[chef_infra::workstation]"
          chef.custom_config_path = "./.chef/knife.rb"
        end

      end

      if instance.type == VirtualMachine::TYPE_KUBE_MASTER || instance.type == VirtualMachine::TYPE_KUBE_NODE

        current.vm.provision "chef_solo" do |chef|
          chef.arguments = "--chef-license accept"

          chef.add_recipe "recipe[chef_infra::default]"
        end

      end

    end
  end

end

# Vagrant.configure("2") do |config|
#   config.ssh.insert_key = false
#   config.vagrant.plugins = %w(vagrant-vbguest vagrant-hostsupdater)
#
#
#   # Chef server
#   config.vm.define CHEF_SERVER_NAME do |chef_server|
#
#     chef_server.vm.synced_folder '.', '/vagrant', type: 'virtualbox'
#     # Hostname and network config
#     chef_server.vm.box = CHEF_SERVER_IMAGE_NAME
#     chef_server.vm.network "private_network", ip: "#{CHEF_SERVER_IP}"
#     chef_server.vm.hostname = CHEF_SERVER_NAME
#
#     chef_server.vm.provider "virtualbox" do |vb|
#       vb.memory = CHEF_SERVER_MEM
#       vb.cpus = CHEF_SERVER_CPU
#     end
#
#     chef_server.vm.provision "chef_solo" do |chef|
#       chef.arguments = "--chef-license accept"
#
#       chef.add_recipe "recipe[chef_infra::default]"
#       chef.add_recipe "recipe[chef_infra::server]"
#     end
#   end
#
#   config.vm.define KUBE_MASTER_NAME do |kube_master|
#
#     # Hostname and network config
#     kube_master.vm.box = KUBE_MASTER_IMAGE_NAME
#     kube_master.vm.network "private_network", ip: "#{KUBE_MASTER_IP}"
#     kube_master.vm.hostname = KUBE_MASTER_NAME
#
#     kube_master.vm.provider "virtualbox" do |vb|
#       vb.memory = KUBE_MASTER_MEM
#       vb.cpus = KUBE_MASTER_CPU
#     end
#
#     #kube_master.vm.provision "chef_client" do |chef|
#     #chef.channel = "stable"
#     #chef.arguments = "--chef-license accept"
#
#     #chef.node_name = 'kube-master'
#
#     #chef.chef_server_url = "https://#{CHEF_SERVER_NAME}/organizations/cheflab"
#     #chef.validation_key_path = "./cookbooks/chef_infra/files/chefadmin.pem"
#     #chef.custom_config_path = "./cookbooks/chef_infra/files/client.rb"
#     #end
#     #end
#   end
#   config.vm.define CHEF_WORKSTATION_NAME do |chef_workstation|
#
#     chef_workstation.vm.synced_folder '.', '/vagrant', type: 'virtualbox'
#     # Hostname and network config
#     chef_workstation.vm.box = CHEF_WORKSTATION_IMAGE_NAME
#     chef_workstation.vm.network "private_network", ip: "#{CHEF_WORKSTATION_IP}"
#     chef_workstation.vm.hostname = CHEF_WORKSTATION_NAME
#
#     chef_workstation.vm.provider "virtualbox" do |vb|
#       vb.memory = CHEF_WORKSTATION_MEM
#       vb.cpus = CHEF_WORKSTATION_CPU
#     end
#
#     chef_workstation.vm.provision "chef_solo" do |chef|
#       chef.arguments = "--chef-license accept"
#
#       chef.add_recipe "recipe[chef_infra::default]"
#       chef.add_recipe "recipe[chef_infra::workstation]"
#       chef.custom_config_path = "./.chef/knife.rb"
#     end
#   end
# end