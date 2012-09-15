libraries = value_for_platform(
  ["ubuntu", "debian"]             => { "default" => ["libyaml-dev", "libxml2-dev",   "libxslt-dev"]    },
  [ "centos", "redhat", "amazon" ] => { "default" => ["libyaml-devel", "libxml2-devel", "libxslt-devel"]  }
)

libraries.each do |name|
  package(name) { action :install }
end
