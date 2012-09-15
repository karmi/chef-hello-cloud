begin
  require 'rubygems'
  require 'active_support/core_ext/hash/deep_merge'
rescue LoadError => e
  STDERR.puts '', '[!] ERROR -- Please install ActiveSupport (gem install activesupport)', '-'*80, ''
  raise e
end

nodes = {

  'database' => {
    :roles    => ['database'],
    :ip       => '33.33.33.20',
    :attributes => {
      :postgresql => {
        :listen_addresses => "*"
      }
    }
  },

  'elasticsearch-1' => {
    :roles    => ['elasticsearch'],
    :ip       => '33.33.33.31',
    :attributes => {
      :elasticsearch => {
        :cluster_name => "chef-hello-cloud",

        :mlockall => false,

        :nginx => {
          :port  => 80,
          :user  => 'www-data',
          :users => [{ username: 'hello', password: 'cloud' }],
          :allow_cluster_api => true
        }
      }
    }
  },

  'application-1' => {
    :roles    => ['application'],
    :ip       => '33.33.33.11',
    :attributes => {}
  },

  'load-balancer' => {
    :roles    => ['load_balancer'],
    :ip       => '33.33.33.10',
    :attributes => {}
  }

}

Vagrant::Config.run do |vagrant|

  nodes.each_pair do |name, node|

    vagrant.vm.define name do |config|
      config.vm.host_name = name.to_s

      config.vm.box     = "precise64"
      config.vm.box_url = "http://files.vagrantup.com/precise64.box"

      config.vm.network :hostonly, node[:ip]
      config.vm.customize { |vm| vm.memory_size = 256 }

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
