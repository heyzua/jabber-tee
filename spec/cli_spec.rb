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
      it "should parse the username correctly" do
        check(:username, ['-u', '--username'], 'someuser')
      end

      it "should parse the password correctly" do
        check(:password, ['-p', '--password'], 'super_!!_secret')
      end
=begin
      it "should parse the sasl flag correctly" do
        check(:sasl, ['--sasl'], true)
      end
      
      it "should parse the digest flag correctly" do
        check(:digest, ['--digest'], true)
      end
      it "should parse the anonymous flag correctly" do
        check(:anonymous, ['-a', '--anonymous'], true)
      end
=end

      it "should parse the room flag correctly" do
        check(:room, ['-r', '--room'], 'ROOM')
      end
     
      it "should parse the nickname flag correctly" do
        check(:nick, ['-n', '--nick'], 'nickname!')
      end
    end

    describe "while validating the arguments" do
      CE = JabberTee::ConfigurationError

      it "should fail when there are extra arguments" do
        attempting_to { validate('extra-arg') }.should raise_error(CE, /extra/)
      end
    end
  end
end
