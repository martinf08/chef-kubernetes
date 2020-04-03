current_dir = File.dirname(__FILE__)
log_level                 :info
log_location              STDOUT
node_name                 "chef-workstation"
client_key                "#{current_dir}/client.pem"
chef_server_url           "https://chef-server/organizations/cheflab/"
cookbook_path             ["#{current_dir}/../cookbooks"]