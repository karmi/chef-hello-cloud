name        "database"
description "Configuration for database servers (Redis, PostgreSQL)"

run_list    "role[base]",
            "recipe[redisio::install]",
            "recipe[redisio::enable]",
            "recipe[postgresql::server]",
            "recipe[application::config]"

override_attributes \
  "postgresql" => {
    "version" => "9.1",
    "dir"     => "/var/lib/pgsql9/data"
  }
