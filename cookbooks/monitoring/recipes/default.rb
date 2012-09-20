package "monit"

# NOTE: Chef is not a tool, dude, Chef is a infrastructure!
#
node.set_unless[:monit][:config] = value_for_platform(
                                      "ubuntu"  => { "default" => "/etc/monit/monitrc" },
                                      "amazon"  => { "default" => "/etc/monit.conf" }
                                   )

service "monit" do
  enabled true
  supports [:start, :restart, :stop, :status]
  action :start
end

template node.monit[:config] do
  owner "root" and group "root" and mode 0700
  source 'monitrc.erb'
  notifies :restart, resources(:service => "monit")
end

directory "/etc/monit/conf.d/" do
  owner  'root' and group 'root' and mode 0755
  recursive true
end
