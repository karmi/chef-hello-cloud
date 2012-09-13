name        "database"
description "Configuration for database servers (Redis, PostgreSQL)"

run_list    "role[base]", "recipe[redis]", "recipe[postgresql]"
