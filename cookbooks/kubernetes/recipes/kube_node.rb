bash 'Join kube_node' do
  code <<-EOH
    sshpass -p "vagrant" rsync -arv -e 'ssh -o StrictHostKeyChecking=no' vagrant@192.168.50.30:/home/vagrant/join_command.txt /home/vagrant/join_command.txt
    sh /home/vagrant/join_command.txt
  EOH
end