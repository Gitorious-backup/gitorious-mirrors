class Command::Init
  GIT_COMMAND  = 'git init --bare'

  def initialize(repo_name, repo_root)
    @repo_name, @repo_root = repo_name, repo_root
  end

  def execute
    "/bin/sh -c \"mkdir -p #{repo_path} && cd #{repo_path} && #{GIT_COMMAND}\""
  end

  private

  def repo_path
    File.join(@repo_root, @repo_name)
  end
end
