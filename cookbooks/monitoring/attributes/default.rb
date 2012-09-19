default.monit[:http_auth] = { :username => "monit", :password => "monitoring" }
default.monit[:poll_period]  = 60
default.monit[:start_delay]  = 0

default.monit[:log]          = '/var/log/monit.log'
default.monit[:pid]          = '/var/run/monit.pid'
