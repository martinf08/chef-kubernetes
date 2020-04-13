describe file('/tmp/terraform_0.12.24_linux_amd64.zip') do
  it { should exist }
end

describe file('/usr/local/bin/terraform') do
  it { should exist }
end