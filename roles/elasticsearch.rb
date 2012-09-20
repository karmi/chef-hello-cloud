name        "elasticsearch"
description "Configuration for elasticsearch nodes"

run_list    "role[base]",
            "recipe[nginx]",
            "recipe[elasticsearch]",
            "recipe[elasticsearch::plugin_aws]",
            "recipe[elasticsearch::proxy_nginx]",
            "recipe[monitoring]",
            "recipe[monitoring::nginx]",
            "recipe[monitoring::elasticsearch]"

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
