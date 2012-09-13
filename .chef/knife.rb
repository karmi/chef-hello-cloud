current_dir = File.dirname(__FILE__)

log_level                :info
log_location             STDOUT

node_name                ENV['USER']
client_key               "#{ENV['HOME']}/.chef/#{ENV['USER']}.pem"
validation_client_name   "webexpo-validator"
validation_key           "#{current_dir}/webexpo-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/webexpo"
cache_options            :path => "#{current_dir}/tmp/checksums"

cookbook_path            ["#{current_dir}/../site-cookbooks", "#{current_dir}/../cookbooks"]
