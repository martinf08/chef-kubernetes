apt_update 'update' do
  frequency 86400
  action :periodic
end

apt_package 'zip'

FILE = "terraform_0.12.24_linux_amd64.zip"

remote_file "/tmp/#{FILE}" do
  source "https://releases.hashicorp.com/terraform/0.12.24/#{FILE}"
  action :create_if_missing
end

bash "Install Terraform" do
  code <<-EOH
  cd /tmp
  unzip #{FILE}
  sudo mv /tmp/terraform /usr/local/bin
  EOH
  not_if { ::File.exist?('/usr/local/bin/terraform') }
end