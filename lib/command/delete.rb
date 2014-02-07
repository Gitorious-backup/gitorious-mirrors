class Command::Delete
  COMMAND = 'rm -Rf'

  InvalidPathError = Class.new(StandardError)

  def initialize(repo_name, repo_root)
    @repo_name, @repo_root = repo_name, repo_root
  end

  def execute
    if valid_path?
      "#{COMMAND} #{repo_path}"
    else
      raise InvalidPathError, "Repository path #{repo_path.inspect} is not valid"
    end
  end

  private

  def repo_path
    File.join(@repo_root, @repo_name)
  end

  def valid_path?
    File.directory?(repo_path)
  end
end
