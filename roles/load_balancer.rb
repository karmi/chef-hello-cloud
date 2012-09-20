name        "load_balancer"
description "Application load balancer settings"

run_list    "role[base]",
            "recipe[haproxy::app_lb]",
            "recipe[monitoring]",
            "recipe[monitoring::haproxy]"

override_attributes(
	"haproxy" => {
		"member_port"     => 80,
		"app_server_role" => "application"
	}
)
