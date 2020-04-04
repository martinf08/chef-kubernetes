describe package('curl') do
  it { should be_installed }
end

describe file('/etc/apt/sources.list.d/kubernetes.list') do
  it { should exist }
end

describe package('kubeadm') do
  it { should be_installed }
end

describe file('/etc/fstab') do
  its('content') { should_not match('/swap/') }
end

describe bash('df -hv') do
  its('stdout') { should_not match /swap/ }
end