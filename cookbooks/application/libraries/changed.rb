module GitChanged

  # Returns true if any of paths passed as arguments were changed between current revision
  # and the `node.application[:previous_revision]` revision. Example:
  #
  #     only_if { changed? 'app/views', 'app/models' }
  #
  # You may pass the revision as the `rev` option:
  #
  #     only_if { changed? 'app/views', 'app/models', :rev => node.application[:some_revision] }
  #
  def changed?(*arguments)
    options = arguments.last.is_a?(Hash) ? arguments.pop : {}
    files   = Array(arguments).flatten

    revision = options[:rev] || node.application[:previous_revision] || 'HEAD^'
    changed_files = changed_files(revision)

    Chef::Log.debug("Running `changed?` for files #{files.inspect} with options: #{options.inspect}")
    Chef::Log.debug("Files changed in revision #{revision}: " + changed_files.inspect)

    files.select { |f| changed_files.any? { |a| a.to_s =~ Regexp.new(Regexp.escape(f)) }  }.size > 0
  end

  def current_revision_sha
    `git --git-dir=#{node.application[:dir]}/#{node.application[:name]}/.git rev-parse HEAD`.strip rescue nil
  end

  def changed_files(revision)
    `cd #{node.application[:dir]}/#{node.application[:name]}/ && git diff --name-only #{revision}`.split
  end
end
