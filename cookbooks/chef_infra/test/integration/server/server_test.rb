describe package('curl') do
  it { should be_installed }
end

describe package('chef-server-core') do
  it { should be_installed }
end

describe directory('/home/vagrant/certs') do
  it { should exist }
end

describe file('/home/vagrant/certs/client.pem') do
  it { should exist }
  its('content') { should match /BEGIN RSA PRIVATE KEY/ }
end

describe bash('curl -Lk localhost') do
  its('stdout') { should match /Username or Email Address/i }
end



