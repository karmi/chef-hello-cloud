name        "database"
description "Configuration for database servers (Redis, PostgreSQL)"

run_list    "role[base]",
            "recipe[redisio::install]",
            "recipe[redisio::enable]",
            "recipe[postgresql::server]",
            "recipe[application::config]"
