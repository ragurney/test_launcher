require "test_helper"
require "test_launcher/rubymine/launcher"

module TestLauncher
  class RubymineTest < TestCase
    def test_launch__run__file
      args = "/Users/username/some_app/bin/spring testunit /Users/username/some_app/engines/some_engine/test/does_something_test.rb"
      expected_command = "cd /Users/username/some_app/engines/some_engine && bundle exec ruby -I test -e 'ARGV.each {|f| require(File.join(Dir.pwd, f))}' test/does_something_test.rb"

      assert_executes expected_command, args
    end

    def test_launch__run__example
      args = "/Users/username/some_app/bin/spring testunit /Users/username/some_app/engines/some_engine/test/does_something_test.rb --name=some_test_name"
      expected_command = "cd /Users/username/some_app/engines/some_engine && bundle exec ruby -I test test/does_something_test.rb --name='some_test_name'"

      assert_executes expected_command, args
    end

    def test_launch__debug__example
      args = "/Users/username/.rvm/gems/ruby-2.2.3/gems/ruby-debug-ide-0.6.1.beta2/bin/rdebug-ide --disable-int-handler --evaluation-timeout 10 --rubymine-protocol-extensions --port 58930 --host 0.0.0.0 --dispatcher-port 58931 -- /Users/username/some_app/bin/spring testunit /Users/username/some_app/engines/some_engine/test/does_something_test.rb --name=some_test_name"

      launcher = Rubymine::Launcher.new(
        args: args.split(" "),
        shell: dummy_shell
      )

      assert ! $LOAD_PATH.include?("/Users/username/some_app/engines/some_engine")
      launcher.expects(:load).with("/Users/username/.rvm/gems/ruby-2.2.3/gems/ruby-debug-ide-0.6.1.beta2/bin/rdebug-ide")

      launcher.launch

      assert_equal "/Users/username/some_app/engines/some_engine/test", $LOAD_PATH.first
      assert_equal "/Users/username/.rvm/gems/ruby-2.2.3/gems/ruby-debug-ide-0.6.1.beta2/bin/rdebug-ide", $0

      # TOTALLY AWESOME SAUCE
      $LOAD_PATH.shift
      $0 = __FILE__
    end

    def test_launch__debug__file
      args = "/Users/username/.rvm/gems/ruby-2.2.3/gems/ruby-debug-ide-0.6.1.beta2/bin/rdebug-ide --disable-int-handler --evaluation-timeout 10 --rubymine-protocol-extensions --port 58930 --host 0.0.0.0 --dispatcher-port 58931 -- /Users/username/some_app/bin/spring testunit /Users/username/some_app/engines/some_engine/test/does_something_test.rb"

      launcher = Rubymine::Launcher.new(
        args: args.split(" "),
        shell: dummy_shell
      )

      assert ! $LOAD_PATH.include?("/Users/username/some_app/engines/some_engine")
      launcher.expects(:load).with("/Users/username/.rvm/gems/ruby-2.2.3/gems/ruby-debug-ide-0.6.1.beta2/bin/rdebug-ide")

      launcher.launch

      assert_equal "/Users/username/some_app/engines/some_engine/test", $LOAD_PATH.first
      assert_equal "/Users/username/.rvm/gems/ruby-2.2.3/gems/ruby-debug-ide-0.6.1.beta2/bin/rdebug-ide", $0

      # TOTALLY AWESOME SAUCE
      $LOAD_PATH.shift
      $0 = __FILE__
    end

    private

    def assert_executes(expected_command, args)
      launcher = Rubymine::Launcher.new(
        args: args.split(" "),
        shell: dummy_shell
      )

      launcher.launch
      assert_equal 1, dummy_shell.recall(:exec).size
      assert_equal [[expected_command]], dummy_shell.recall(:exec)

    end
  end
end