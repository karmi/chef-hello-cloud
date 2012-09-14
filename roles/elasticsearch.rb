name        "elasticsearch"
description "Configuration for elasticsearch nodes"

run_list    "role[base]",
            "recipe[java]",
            "recipe[nginx]",
            "recipe[elasticsearch]",
            "recipe[elasticsearch::plugin_aws]",
            "recipe[elasticsearch::proxy_nginx]"
