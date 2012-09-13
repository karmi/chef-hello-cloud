begin
  require 'rubygems'
  require 'active_support/core_ext/hash/deep_merge'
rescue LoadError => e
  STDERR.puts '', '[!] ERROR -- Please install ActiveSupport (gem install activesupport)', '-'*80, ''
  raise e
end

nodes = {

  'application-1' => {
    :roles    => ['application'],
    :ip       => '33.33.33.11',
    :attributes => {}
  },

  'application-2' => {
    :roles    => ['application'],
    :ip       => '33.33.33.12',
    :attributes => {}
  },

  'application-3' => {
    :roles    => ['application'],
    :ip       => '33.33.33.13',
    :attributes => {}
  },

  'load-balancer' => {
    :roles    => ['load_balancer'],
    :ip       => '33.33.33.10',
    :attributes => {}
  },

  'database' => {
    :roles    => ['database'],
    :ip       => '33.33.33.20',
    :attributes => {}
  },  

}

Vagrant::Config.run do |vagrant|

  nodes.each_pair do |name, node|

    vagrant.vm.define name do |config|
      config.vm.host_name = name.to_s

      config.vm.box     = "precise64"
      config.vm.box_url = "http://files.vagrantup.com/precise64.box"

      config.vm.network :hostonly, node[:ip]

      # Enable provisioning with Chef Server
      config.vm.provision :chef_client do |chef|
        chef.chef_server_url        = "https://api.opscode.com/organizations/webexpo"
        chef.validation_key_path    = ".chef/webexpo-validator.pem"
        chef.validation_client_name = "webexpo-validator"

        node[:roles].each { |role| chef.add_role role }

        chef.json       = { :cloud => {
                              :provider    => "vagrant",
                              :local_ipv4  => node[:ip],
                              :public_ipv4 => node[:ip]
                            }
                          }.deep_merge(node[:attributes])
      end
    end
  
  end

end
