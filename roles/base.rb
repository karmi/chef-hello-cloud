name        "base"
description "Basic tools and utilities for all nodes"

run_list    "recipe[build-essential]",
            "recipe[curl]",
            "recipe[vim]"
