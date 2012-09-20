name        "database"
description "Configuration for database servers (Redis, PostgreSQL)"

run_list    "role[base]",
            "recipe[redisio::install]",
            "recipe[redisio::enable]",
            "recipe[postgresql::server]",
            "recipe[application::config]",
            "recipe[monitoring]",
            "recipe[monitoring::redis]",
            "recipe[monitoring::postgresql]"

override_attributes \
  "postgresql" => {
    "listen_addresses" => "*"
  }