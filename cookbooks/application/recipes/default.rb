# Load the GitChanged extension
#
[Chef::Recipe, Chef::Resource].each { |l| l.send :include, GitChanged }

# Install libraries
#
include_recipe "application::libraries"

# Install required Ruby version with RVM
#
include_recipe "application::ruby"

# Set environment variables for connecting to other parts of the stack
#
ruby_block "set environment variables" do
  block do
    node_prefix = node.name.to_s.split('-').first
    if database = search("node", "role:database AND name:#{node_prefix}*").first
      host = database.attribute?(:cloud) ? database[:cloud][:local_ipv4] : database[:ipaddress]
      Chef::Log.info %Q|Database node: #{host}|

      ENV['POSTGRESQL_HOST']     = host
      ENV['POSTGRESQL_USER']     = database[:postgresql][:password].keys.first
      ENV['POSTGRESQL_PASSWORD'] = database[:postgresql][:password].values.first
      ENV['REDISTOGO_URL']       = "redis://#{host}:6379/"
    else
      Chef::Log.fatal %Q|[!] Can't find a database node in Chef: ('search("node", "role:database AND name:#{node_prefix}*")')|
    end

    if elasticsearch = search("node", "role:elasticsearch AND name:#{node_prefix}*").first
      host = elasticsearch.attribute?(:cloud) ? elasticsearch[:cloud][:local_ipv4] : elasticsearch[:ipaddress]
      Chef::Log.info %Q|elasticsearch node: #{host}|

      ENV['ELASTICSEARCH_URL'] = "http://#{host}:9200"
    else
      Chef::Log.fatal %Q|[!] Can't find an elasticsearch node in Chef: ('search("node", "role:elasticsearch AND name:#{node_prefix}*")')|
    end
  end
end

# Store current revision as "previous_revision"
#
ruby_block "save previous revision" do
  block { node.application[:previous_revision] = current_revision_sha }
end

# Create user and group
#
group node.application[:user] do
  action :create
end
user node.application[:user] do
  comment  "Application User"
  gid      "application"
  shell    "/bin/bash"
  action   :create
end
group node.application[:user] do
  members [ node.application[:user] ]
  action :create
end

# Add user to RVM group
#
group "rvm" do
  members [ node.application[:user] ]
  action :modify
end

# Install the Thin webserver
#
include_recipe "application::thin"

# Create log directory
#
directory "/usr/local/var/log/#{node.application[:name]}" do
  owner node.application[:user] and group node.application[:user]
  recursive true
end

# Create applications directory
#
directory node.application[:dir] do
  owner node.application[:user] and group node.application[:user] and mode 0755
  recursive true
  action :create
end

# Clone repository
#
git "#{node.application[:dir]}/#{node.application[:name]}" do
  repository node.application[:repo]
  user node.application[:user] and group node.application[:user]
  reference node.application[:branch]
  depth 1
  action :sync
end

# Save current revision to node
#
ruby_block "save current revision" do
  block { node.application[:current_revision] = current_revision_sha }
end

# Delete default Nginx configuration files
#
bash "delete default configuration files" do
  code <<-COMMAND
    rm -f /etc/nginx/conf.d/*
  COMMAND

  only_if "test -f /etc/nginx/conf.d/default.conf"
  notifies :reload, "service[nginx]"
end

# Create application configuration file for Nginx
#
template "#{node[:nginx][:dir]}/sites-enabled/#{node.application[:name]}.conf" do
  source "application.conf.erb"
  owner node[:nginx][:user] and group node[:nginx][:user] and mode 0755
  action :create

  notifies :restart, "service[nginx]"
end

# Create application init script
#
service "application" do; end
template "/etc/init.d/application" do
  source "application.initd.erb"
  owner node.application[:user] and group node.application[:user] and mode 0755
  action :create

  notifies :restart, "service[application]"
end

# Create database.yml
#
template "#{node.application[:dir]}/#{node.application[:name]}/config/database.yml" do
  source "database.yml.erb"
  owner node[:nginx][:user] and group node[:nginx][:user] and mode 0755
  action :create

  notifies :restart, "service[application]"
end

# Install Bundler
#
gem_package "bundler" do
  action :install
end

# Bundle install
#
bash "bundle install" do
  code <<-COMMAND
    su - #{node.application[:user]} -m -c '
      cd #{node.application[:dir]}/#{node.application[:name]}
      rvm use #{node.application[:ruby][:version]}
      bundle install --deployment --binstubs --without development test
    '
  COMMAND

  only_if do
    changed?('Gemfile', 'Gemfile.lock') ||
    ! File.exists?("#{node.application[:dir]}/#{node.application[:name]}/vendor/bundle")
  end

  notifies :restart, "service[application]"
end

# Create Thin configuration for the application
#
directory "/etc/thin" do; owner node.application[:user] and group node.application[:user]; end
ruby_block "configure the application for Thin" do
  block do

    thin_configuration = <<-COMMAND
      thin config \
        --config /etc/thin/#{node.application[:name]}.yml \
        --environment development \
        --chdir #{node.application[:dir]}/#{node.application[:name]} \
        --rackup #{node.application[:dir]}/#{node.application[:name]}/config.ru \
        --tag #{node.application[:name]} \
        --socket #{node.application[:thin][:sockets]}/#{node.application[:name]}.sock \
        --pid #{node.application[:thin][:pids]}/#{node.application[:name]}.pid \
        --log #{node.application[:dir]}/#{node.application[:name]}/log/thin.log \
        --servers #{node.application[:thin][:servers]} \
        --user #{node.application[:user]} \
        --group #{node.application[:user]} \
        --onebyone \
        --daemonize
    COMMAND
    Chef::Log.debug thin_configuration

    system thin_configuration
  end

  not_if "test -f /etc/thin/#{node.application[:name]}.yml"

  notifies :restart,  "service[application]"
  notifies :reload, "service[nginx]"
end
