# When running in Vagrant, we need clients to connect to PostgreSQL via the eth1 IPs
#
if node.attribute?(:vagrant) and node.attribute?(:postgresql)

  bash "allow PostgreSQL clients connecting to 33.33.33.* IPs" do
    code <<-COMMAND
    echo ''                                                         >> /etc/postgresql/9.1/main/pg_hba.conf
    echo '# Allow connections from application'                     >> /etc/postgresql/9.1/main/pg_hba.conf
    echo 'host    all         all         33.33.33.0/24        md5' >> /etc/postgresql/9.1/main/pg_hba.conf
    COMMAND

    not_if "grep 33.33.33.0 /etc/postgresql/9.1/main/pg_hba.conf"

    notifies :restart, "service[postgresql]"
  end

end

if node.attribute?(:postgresql)
  # Export locale environment variable
  bash 'export LC_ALL="en_US.UTF-8"' do
    code <<-COMMAND
      echo 'export LC_ALL="en_US.UTF-8"' > /etc/profile.d/locale.sh
    COMMAND
  end
end
