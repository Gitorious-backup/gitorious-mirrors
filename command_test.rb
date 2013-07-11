require 'minitest/autorun'
require 'mocha/setup'

class Command
  SEPARATOR = ' '.freeze

  def initialize(original_command, repo_root)
    @original_command = original_command
    @repo_root = repo_root
  end

  def execute
    %(git-shell -c "#{create_command}")
  end

  private

  def create_command
    slices = @original_command.split(SEPARATOR)
    path   = File.join(@repo_root, slices.pop)

    slices << path

    slices.join(SEPARATOR)
  end
end

class Command::Init
  GIT_COMMAND  = 'git init --bare'

  def initialize(repo_name, repo_root)
    @repo_name, @repo_root = repo_name, repo_root
  end

  def execute
    "/bin/sh -c mkdir #{repo_path} && cd #{repo_path} && #{GIT_COMMAND}"
  end

  private

  def repo_path
    File.join(@repo_root, @repo_name)
  end
end

class Command::Clone
  GIT_COMMAND = 'git clone'

  def initialize(source, target, repo_root)
    @source, @target, @repo_root = source, target, repo_root
  end

  def execute
    "#{GIT_COMMAND} /var/git/#{@source} /var/git/#{@target}"
  end
end

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
      raise InvalidPathError, "Repository root #{@repo_root.inspect} is not valid"
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

describe Command do
  before do
    @command = Command.new('git upload-pack foo.git', '/var/git')
  end

  it 'creates command for git-shell' do
    assert_equal 'git-shell -c "git upload-pack /var/git/foo.git"', @command.execute
  end
end

describe Command::Init do
  before do
    @action = Command::Init.new('foo', '/var/git')
  end

  it 'executes git init command' do
    assert_equal '/bin/sh -c mkdir /var/git/foo && cd /var/git/foo && git init --bare', @action.execute
  end
end

describe Command::Clone do
  before do
    @action = Command::Clone.new('source', 'target', '/var/git')
  end

  it 'executes git clone command' do
    assert_equal 'git clone /var/git/source /var/git/target', @action.execute
  end
end

describe Command::Delete do
  before do
    @action = Command::Delete.new('foo.git', '/var/git')
  end

  describe 'when directory does not exist' do
    it 'raises an error' do
      File.expects(:directory?).with('/var/git/foo.git').returns(false)

      assert_raises Command::Delete::InvalidPathError do
        @action.execute
      end
    end
  end

  describe 'path is valid' do
    it 'removes the repository' do
      File.expects(:directory?).with('/var/git/foo.git').returns(true)
      assert_equal 'rm -Rf /var/git/foo.git', @action.execute
    end
  end
end
