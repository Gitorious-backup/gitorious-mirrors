class Command
  SEPARATOR = ' '.freeze

  def self.build(original_command, repo_root="/var/git")
    slices = original_command.split(' ')
    verb   = slices.shift

    type =
      case verb
      when 'init'   then Command::Init
      when 'clone'  then Command::Clone
      when 'delete' then Command::Delete
      when 'git-receive-pack' then Command::Git
      else
        raise ArgumentError, "command #{original_command.inspect} is not supported"
      end

    type.new(*slices, repo_root)
  end

  def initialize(original_command, repo_root)
    @original_command = original_command
    @repo_root = repo_root
  end

  private

  def create_command
    slices = @original_command.split(SEPARATOR)
    path   = File.join(@repo_root, slices.pop)

    slices << path

    slices.join(SEPARATOR)
  end
end
