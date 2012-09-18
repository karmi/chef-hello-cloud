default.application[:user]   = "application"
default.application[:dir]    = "/usr/local/var/applications"

default.application[:domain] = "rubygems.org"

default.application[:repo]   = "git://github.com/karmi/rubygems.org.git"
default.application[:name]   = "rubygems.org"
default.application[:branch] = "deploy"

default.application[:ruby][:version] = "1.9.3-p0"

default.application[:thin][:servers] = 3
default.application[:thin][:sockets] = "/var/run/thin/sockets"
default.application[:thin][:pids]    = "/var/run/thin/pids"
