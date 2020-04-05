describe file('/etc/kubernetes/manifests/kube-apiserver.yaml') do
  it { should exist }
end
describe bash('kubectl get node') do
  its('stdout') { should match /master/ }
  its('stdout') { should match /node/ }
end