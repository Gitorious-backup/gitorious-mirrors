require 'minitest/autorun'

class Command
  GIT_CLONE_COMMAND = 'git clone'

  def initialize(original_command)
    @action, @path = original_command.split(' ')
  end

  def execute
    if @action == 'init'
      Command::Init.new(@path, '/var/git').execute
    elsif @action == 'clone'
      "#{GIT_CLONE_COMMAND} /var/git/source /var/git/target"
    end
  end
end

class Command::Init
  GIT_INIT_COMMAND  = 'git init --bare'

  def initialize(repo_name, repo_root)
    @repo_name, @repo_root = repo_name, repo_root
  end

  def execute
    "/bin/sh -c mkdir #{repo_path} && cd #{repo_path} && #{GIT_INIT_COMMAND}"
  end

  private

  def repo_path
    File.join(@repo_root, @repo_name)
  end
end

describe Command do
  describe 'init' do
    before do
      @command = Command.new('init foo')
    end

    it 'works' do
      assert_equal '/bin/sh -c mkdir /var/git/foo && cd /var/git/foo && git init --bare', @command.execute
    end
  end

  describe 'clone' do
    before do
      @command = Command.new('clone source target')
    end

    it 'works' do
      assert_equal 'git clone /var/git/source /var/git/target', @command.execute
    end
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
