namespace :server do


  desc "Create server with specified name and role"
  task :create do

    ["NAME", "ROLE"].each { |argument| ( puts("[!] You need to specify #{argument}"); exit(1) ) unless ENV[argument] }

    start  = Time.now
    flavor = ENV["FLAVOR"] || "c1.xlarge"

    system "knife ec2 server create --node-name #{ENV["NAME"]} \
                                    --ssh-user ec2-user \
                                    --run-list 'role[#{ENV["ROLE"]}]' \
                                    --groups #{ENV["ROLE"]} \
                                    --flavor #{flavor} \
                                    --distro amazon"

  end

  desc "Delete server"
  task :delete do

    ["NAME"].each { |argument| ( puts("[!] You need to specify #{argument}"); exit(1) ) unless ENV[argument] }

    nodes = `knife status --no-color`

    attrs = nodes.split("\n").select { |line| line =~ Regexp.new( Regexp.escape(ENV["NAME"]) ) }.first.split(',', 5) rescue []
    ip = attrs[3]

    if ip
      servers = `knife ec2 server list --no-color`
      attrs = servers.split("\n").select { |line| line =~ Regexp.new( Regexp.escape(ip.strip) ) }.first.split(/\s+/, 8) rescue []

      instance_id = attrs[0]

      if instance_id
        system "knife ec2 server delete #{instance_id.strip} --print-after --yes"
        system "knife node delete #{ENV["NAME"]} --yes"
        system "knife client delete #{ENV["NAME"]} --yes"
      else
        puts "[!] No server for node #{ENV["NAME"]} found"
      end
    else
      puts "[!] No node named #{ENV["NAME"]} found"
    end

  end

end