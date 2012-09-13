Vagrant::Config.run do |vagrant|

  vagrant.vm.define :application_1 do |config|
    config.vm.host_name = "application-1"

    config.vm.box     = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.network :hostonly, "33.33.33.11"

    # Enable provisioning with Chef Server
    config.vm.provision :chef_client do |chef|
      chef.chef_server_url        = "https://api.opscode.com/organizations/webexpo"
      chef.validation_key_path    = ".chef/webexpo-validator.pem"
      chef.validation_client_name = "webexpo-validator"

      chef.add_role   'application'
      chef.json       = { "cloud" => {
                            "provider"    => "vagrant",
                            "local_ipv4"  => "33.33.33.11",
                            "public_ipv4" => "33.33.33.11"
                          }
                        }
    end
  end

  vagrant.vm.define :application_2 do |config|
    config.vm.host_name = "application-2"

    config.vm.box     = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.network :hostonly, "33.33.33.12"
    # config.vm.network :hostonly, "10.0.0.12",   :adapter => 1, :auto_config => false
    # config.vm.network :hostonly, "33.33.33.11", :adapter => 2, :auto_config => false
    # config.vm.network :hostonly, "10.0.2.12",   :adapter => 1
    # config.vm.network :hostonly, "33.33.33.12", :adapter => 2

    # Enable provisioning with Chef Server
    config.vm.provision :chef_client do |chef|
      chef.chef_server_url        = "https://api.opscode.com/organizations/webexpo"
      chef.validation_key_path    = ".chef/webexpo-validator.pem"
      chef.validation_client_name = "webexpo-validator"

      chef.add_role   'application'

      chef.json = { :foo => 'bar' }
    end
  end

  vagrant.vm.define :load_balancer, :primary => true do |config|
    config.vm.host_name = "load-balancer"

    config.vm.box     = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.network :hostonly, "33.33.33.10"

    # Enable provisioning with Chef Server
    config.vm.provision :chef_client do |chef|
      chef.chef_server_url        = "https://api.opscode.com/organizations/webexpo"
      chef.validation_key_path    = ".chef/webexpo-validator.pem"
      chef.validation_client_name = "webexpo-validator"

      chef.add_role   'load_balancer'
    end
  end

end
