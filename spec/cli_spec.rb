require 'helpers'
require 'jabber-tee/cli'

module JabberTee

  module CLIHelper
    def parse(*args)
      cli = CLI.new(args)
      cli.parse_options(args)
      cli
    end

    def validate(*args)
      cli = CLI.new(args)
      cli.parse_options(args)
      cli.validate_args(args)
      cli
    end

    def check(sym, flags, value)
      flags.each do |flag|
        if value.is_a?(String)
          parse(flag, value).options[sym].should eql(value)
        else
          parse(flag).options[sym].should eql(value)
        end
      end
    end
  end
  
  describe "Jabber Tee CLI interface" do
    include CLIHelper

    describe "when just checking arguments" do
      it "should parse the server name correctly" do
        check(:server, ['-s', '--server'], 'some.server.com')
      end

      it "should parse the username correctly" do
        check(:username, ['-u', '--username'], 'someuser')
      end

      it "should parse the password correctly" do
        check(:password, ['-p', '--password'], 'super_!!_secret')
      end

      it "should parse the sasl flag correctly" do
        check(:sasl, ['--sasl'], true)
      end
      
      it "should parse the digest flag correctly" do
        check(:digest, ['--digest'], true)
      end

      it "should parse the anonymous flag correctly" do
        check(:anonymous, ['-a', '--anonymous'], true)
      end

      it "should parse the nocolor flag correctly" do
        check(:nocolor, ['--nocolor'], true)
      end

      it "should parse the stdout flag correctly" do
        check(:stdout, ['--stdout'], 'COLOR')
      end

      it "should parse the stderr flag correctly" do
        check(:stderr, ['--stderr'], 'COLOR')
      end
    end

    describe "while validating the arguments" do
      CE = JabberTee::ConfigurationError

      it "should fail when there are extra arguments" do
        attempting_to { validate('extra-arg') }.should raise_error(CE, /extra/)
      end

      it "should fail when the username and anonymous aren't specified." do
        attempting_to { validate('-p', 'password') }.should raise_error(CE, /username or anonymous/)
      end

      it "should fail when the 'to' isn't specified." do
        attempting_to { validate('--username', 'u') }.should raise_error(CE, /to/)
      end
    end
  end
end
