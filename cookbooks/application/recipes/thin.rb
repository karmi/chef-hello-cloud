# Install the Thin webserver
#
gem_package "thin" do
  action :install
end

# Create directory for Thin sockets
#
directory "#{node.application[:thin][:sockets]}" do
  owner node.application[:user] and group node.application[:user] and mode 0755
  action :create
  recursive true
end

# Create directory for Thin pid files
#
directory "#{node.application[:thin][:pids]}" do
  owner node.application[:user] and group node.application[:user] and mode 0755
  action :create
  recursive true
end
