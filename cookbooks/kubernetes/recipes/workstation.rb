remote_file '/usr/local/bin/kubectl' do
  source 'https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl'
  mode '0755'
  action :create_if_missing
end