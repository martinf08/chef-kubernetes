require_relative 'VirtualMachine'

module VmsModule

  FILE_DIR = './cookbooks/chef_infra/files'

  VMS = [
      {
          name: 'chef-server',
          image_name: 'ubuntu/bionic64',
          ip: '192.168.50.10',
          cpu: 2,
          mem: 2048,
          type: VirtualMachine::TYPE_CHEF_SERVER

      },
      {
          name: 'kube-master',
          image_name: 'ubuntu/bionic64',
          ip: '192.168.50.30',
          cpu: 2,
          mem: 2048,
          type: VirtualMachine::TYPE_KUBE_MASTER
      },
      {
          name: 'kube-node',
          image_name: 'ubuntu/bionic64',
          ip: '192.168.50.40',
          cpu: 1,
          mem: 1024,
          type: VirtualMachine::TYPE_KUBE_NODE
      },
      {
          name: 'chef-workstation',
          image_name: 'ubuntu/bionic64',
          ip: '192.168.50.20',
          cpu: 1,
          mem: 1024,
          type: VirtualMachine::TYPE_CHEF_WORKSTATION

      }
  ]

  def self.get_instances

    vms = []
    VMS.each do |attributes|
      vms << VirtualMachine.new(attributes)
    end

    vms
  end

  def self.write_host_file

    Dir.mkdir(FILE_DIR) unless File.exists?(FILE_DIR)

    File.open(FILE_DIR + '/hosts.txt', 'w') do |file|

      VMS.each do |attributes|
        file.write(attributes[:ip] + "   " + attributes[:name] + "\n")
      end

    end
  end

  def self.get_host_bag

    attr = []
    VMS.each do |attributes|
      attr << attributes[:ip] + "   " + attributes[:name] + "\n"
    end

    attr.to_json
  end

end