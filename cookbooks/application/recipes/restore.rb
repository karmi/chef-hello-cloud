ruby_block "create the database" do
  block do
    command = <<-COMMAND
      sudo su - #{node.application[:user]} -m -c '
        cd #{node.application[:dir]}/#{node.application[:name]} && \
        bundle exec rake db:create && \
        bundle exec rake db:schema:load
      '
    COMMAND
    Chef::Log.debug command

    system command
  end

  not_if do
    command = <<-COMMAND
      PGPASSWORD=#{ENV['POSTGRESQL_PASSWORD']} psql \
        --host=#{ENV['POSTGRESQL_HOST']} \
        --username=postgres \
        --dbname=gemcutter_development \
        --command '' > /dev/null 2>&1
    COMMAND
    Chef::Log.debug command

    system command
  end
end

ruby_block "restore the database" do
  block do
    command = <<-COMMAND
      curl -# https://s3.amazonaws.com/webexpo-chef/gemcutter_development.sql | \
      PGPASSWORD=#{ENV['POSTGRESQL_PASSWORD']} psql \
        --host=#{ENV['POSTGRESQL_HOST']} \
        --username=postgres \
        --dbname=gemcutter_development
    COMMAND
    Chef::Log.debug command

    system command
  end

  only_if do
    command = <<-COMMAND
      PGPASSWORD=#{ENV['POSTGRESQL_PASSWORD']} psql \
        --host=#{ENV['POSTGRESQL_HOST']} \
        --username=postgres \
        --dbname=gemcutter_development \
        --command 'SELECT id FROM rubygems LIMIT 1;' | \
      grep '0 rows'
    COMMAND
    Chef::Log.debug command

    system command
  end
end
