require_relative 'src/VmsModule'

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

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


      current.vm.provision "chef_solo" do |chef|
        chef.arguments = "--chef-license accept"

        chef.json = {
            :hosts => VmsModule::get_host_bag
        }

        case instance.type
        when VirtualMachine::TYPE_CHEF_SERVER
          chef.add_recipe "recipe[chef_infra::default]"
          chef.add_recipe "recipe[chef_infra::server]"

        when VirtualMachine::TYPE_CHEF_WORKSTATION
          chef.add_recipe "recipe[chef_infra::default]"
          chef.add_recipe "recipe[chef_infra::workstation]"
          chef.add_recipe "recipe[kubernetes::workstation]"
          chef.custom_config_path = "./.chef/knife.rb"

        when VirtualMachine::TYPE_KUBE_MASTER, VirtualMachine::TYPE_KUBE_NODE
          chef.add_recipe "recipe[chef_infra::default]"
        else
          raise StandardError, 'Type of VirtualMachine not found'
        end

      end
    end
  end
end