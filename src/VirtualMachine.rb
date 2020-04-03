class VirtualMachine

  TYPE_CHEF_SERVER = 1
  TYPE_CHEF_WORKSTATION = 2
  TYPE_KUBE_MASTER = 3
  TYPE_KUBE_NODE = 4

  attr_accessor :name, :image_name, :ip, :cpu, :mem, :type

  def initialize(attr)
    @name = attr[:name]
    @image_name = attr[:image_name]
    @ip = attr[:ip]
    @cpu = attr[:cpu]
    @mem = attr[:mem]
    @type = attr[:type]
  end

  def need_synced_folder?
    [1, 2].include? @type
  end

end