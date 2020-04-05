bash 'Join kube_node' do
  code <<-EOH
    sh /vagrant/cookbooks/kubernetes/files/join_command.txt
  EOH
end