# When running in Vagrant, we need clients to connect to PostgreSQL via the eth1 IPs
#
if node.attribute?(:vagrant) and node.attribute?(:postgresql)

  bash "allow PostgreSQL clients connecting to 33.*.*.* IPs" do
    code <<-COMMAND
    echo 'host    all         all         33.33.33.10/19        md5' >> /etc/postgresql/9.1/main/pg_hba.conf
    COMMAND
    not_if "grep 33.33.33 /etc/postgresql/9.1/main/pg_hba.conf"
  end

end
