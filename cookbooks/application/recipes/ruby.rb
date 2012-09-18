@rvm_username  = node.attribute?(:vagrant) ? 'vagrant' : Chef::Config[:knife][:ssh_user]
@rvm_trace     = Chef::Config[:log_level] == 'debug' ? '--trace' : ''

Chef::Log.info "RVM will be installed as user: #{@rvm_username}"

group "rvm" do
  members [ "root" ]
  action :create
end

bash "install RVM" do
  code <<-COMMAND
    su - #{@rvm_username} -m -c 'curl -# -k -L https://get.rvm.io | sudo bash -s stable #{@rvm_trace}'
  COMMAND

  environment 'TERM' => 'dumb'
  not_if      "su - #{@rvm_username} -m -c 'test -d /usr/local/rvm/ && type rvm'"
end

bash "install Ruby #{node.application[:ruby][:version]}" do
  code <<-COMMAND
    su - #{@rvm_username} -m -c 'rvm install #{node.application[:ruby][:version]}'
    su - #{@rvm_username} -m -c 'rvm system --default'
  COMMAND

  environment 'TERM' => 'dumb'
  not_if      "su - #{@rvm_username} -m -c 'rvm list | grep #{node.application[:ruby][:version]}'"
end

bash 'disable rvmrc check"' do
  code <<-COMMAND
    echo 'rvm_trust_rvmrcs_flag=1' >> /etc/profile.d/rvm.sh
    source /etc/profile.d/rvm.sh
  COMMAND

  not_if { File.read('/etc/profile.d/rvm.sh').include?('rvm_trust_rvmrcs_flag=1') }
end