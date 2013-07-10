require 'minitest/autorun'

class Command
  GIT_INIT_COMMAND = 'git init --bare'

  def initialize(original_command)
    @action, @path = original_command.split(' ')
  end

  def execute
    "/bin/sh -c mkdir #{repo_path} && cd #{repo_path} && #{GIT_INIT_COMMAND}"
  end

  private

  def repo_path
    "/var/git/#{@path}"
  end
end

describe Command do
  before do
    @command = Command.new("init foo")
  end

  it 'works' do
    assert_equal '/bin/sh -c mkdir /var/git/foo && cd /var/git/foo && git init --bare', @command.execute
  end
end
