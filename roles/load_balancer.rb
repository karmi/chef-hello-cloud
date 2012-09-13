name        "load_balancer"
description "Application load balancer settings"

run_list    "role[base]", "recipe[haproxy::app_lb]"

override_attributes(
	"haproxy" => {
		"member_port"     => 80,
		"app_server_role" => "application"
	}
)
