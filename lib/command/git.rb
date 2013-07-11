class Command::Git
  def initialize(repo, repo_root)
    @repo, @repo_root = repo, repo_root
  end

  def execute
    "git-shell -c \"git-receive-pack #{repo_path}\""
  end

  private

  def repo_path
    File.join(@repo_root, @repo)
  end
end
