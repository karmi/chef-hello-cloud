name        "elasticsearch"
description "Configuration for elasticsearch nodes"

run_list    "role[base]",
            "recipe[monitoring]",
            "recipe[nginx]",
            "recipe[monitoring::nginx]",
            "recipe[elasticsearch]",
            "recipe[elasticsearch::plugin_aws]",
            "recipe[elasticsearch::proxy_nginx]"

override_attributes(
  "elasticsearch" => {
    "cluster_name" => "chef-hello-cloud",
    "discovery"    => {
      "type" => "ec2"
    },
    "cloud" => {
      "aws" => { "access_key" => ENV["AWS_ACCESS_KEY_ID"], "secret_key" => ENV["AWS_SECRET_ACCESS_KEY"] },
      "ec2" => { "security_group" => "elasticsearch" }
    },
    "nginx" => {
      "users" => [{ "username" => 'hello', "password" => 'cloud' }],
      "allow_cluster_api" => true
    }
  }
)