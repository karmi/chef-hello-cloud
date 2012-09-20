node.set_unless[:postgresql][:pidfile] = value_for_platform(
                                            "ubuntu"  => { "default" => "/var/run/postgresql/9.1-main.pid" },
                                            "amazon"  => { "default" => "/var/run/postmaster.5432.pid" }
                                         )

monitrc("postgresql")
