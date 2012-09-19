require 'json'

begin
  path = Dir[ Gem.path.first + '/gems' + '/terminal-notifier-*/lib/terminal-notifier.rb' ].first
  require path
rescue Exception
  return nil
end


def notify options={}
  return nil unless defined?(TerminalNotifier)

  TerminalNotifier.notify options[:message],
                          title: options[:name],
                          subtitle: options[:public_ip],
                          open: "http://#{options[:public_ip]}"
end

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

    node     = JSON.parse(`knife node show #{ENV["NAME"]} --format json --attribute ec2`) rescue nil
    duration = ((Time.now-start).to_i/60.0).round
    notify name: ENV["NAME"], public_ip: node["ec2"]["public_hostname"], message: "Created in #{duration} minutes" if node
  end

  desc "Delete server"
  task :delete do

    ["NAME"].each { |argument| ( puts("[!] You need to specify #{argument}"); exit(1) ) unless ENV[argument] }

    node = JSON.parse(`knife node show #{ENV["NAME"]} --format json --attribute ec2`) rescue nil

    ( puts "[!] No node named #{ENV["NAME"]} found"; exit(1) ) unless node

    instance_id = node["ec2"]["instance_id"]

    if instance_id
      system "knife ec2 server delete #{instance_id.strip} --print-after --yes"
      system "knife node delete #{ENV["NAME"]} --yes"
      system "knife client delete #{ENV["NAME"]} --yes"
    else
      puts "[!] No server for node #{ENV["NAME"]} found"
    end

  end

  desc "Delete and terminate all nodes"
  task :teardown do
    prefix = ENV['PREFIX'] || 'ec2'

    nodes = JSON.parse(`knife search node name:#{prefix}* --format json --attribute ec2`) rescue {}

    unless nodes.empty?
      nodes["rows"].each do |node|
        instance_id = node["ec2"]["instance_id"] rescue nil
        system "knife ec2 server delete #{instance_id.strip} --print-after --yes" if instance_id
      end

      system "knife node bulk delete '#{prefix}' --yes"
      system "knife client bulk delete '#{prefix}' --yes"
    end

  end

end
