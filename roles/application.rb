name        "application"
description "Application server configuration"

run_list    "role[base]", "recipe[nginx]"
