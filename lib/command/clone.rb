class Command::Clone
  GIT_COMMAND = 'git clone'

  def initialize(source, target, repo_root)
    @source, @target, @repo_root = source, target, repo_root
  end

  def execute
    "#{GIT_COMMAND} /var/git/#{@source} /var/git/#{@target}"
  end
end
