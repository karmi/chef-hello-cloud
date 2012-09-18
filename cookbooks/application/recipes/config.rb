# When running in Vagrant, we need clients to connect to PostgreSQL via the eth1 IPs
#
if node.attribute?(:cloud) and node.attribute?(:postgresql)

  bash "allow external PostgreSQL clients" do
    code <<-COMMAND
    echo ''                                                         >> #{node.postgresql[:dir]}/pg_hba.conf
    echo '# Allow connections from outside'                         >> #{node.postgresql[:dir]}/pg_hba.conf
    echo 'host    all         all         0.0.0.0/0            md5' >> #{node.postgresql[:dir]}/pg_hba.conf
    COMMAND

    not_if "grep 0.0.0.0/0 #{node.postgresql[:dir]}/pg_hba.conf"

    notifies :restart, "service[postgresql]"
  end

end
