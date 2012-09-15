group "rvm" do
  members [ "root" ]
  action :create
end

bash "install RVM" do
  puts Chef::Config[:ssh_user]

  username  = node.attribute?(:vagant) ? 'vagrant' : Chef::Config[:ssh_user]
  trace     = Chef::Config[:log_level] == 'debug' ? '--trace' : ''

  Chef::Log.info "Installing RVM as #{username}"

  user username
  code <<-COMMAND
    sudo su - #{username} -m -c 'curl -# -k -L https://get.rvm.io | sudo bash -s stable #{trace}'
  COMMAND

  not_if "test -d /usr/local/rvm/ && rvm info"
end

bash "install Ruby #{node.application[:ruby][:version]}" do
  code "rvm install #{node.application[:ruby][:version]}"

  not_if "rvm list | grep #{node.application[:ruby][:version]}"
end
