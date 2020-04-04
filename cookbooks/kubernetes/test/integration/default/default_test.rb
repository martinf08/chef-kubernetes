describe group('docker') do
  it { should exist }
end

describe user('vagrant') do
  it { should exist }
  its('group') { should include 'docker' }
end

describe package('docker-ce docker-ce-cli containerd.io') do
  it { should be_installed}
end

describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end
