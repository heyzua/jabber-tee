require 'optparse'
require 'jabber-tee/errors'
require 'jabber-tee/version'
require 'jabber-tee/client'
require 'jabber-tee/configuration'

module JabberTee
  class CLI
    attr_reader :options, :args

    def initialize(args)
      @args = args
    end

    def execute!
      begin
        parse!(@args.dup)
        config = load_configuration

        if config.destination_missing?
          raise JabberTee::ConfigurationError.new("Either the --to or --room flag is required.")
        end

        client = Client.new(config)
        client.pump!
      rescue SystemExit => e
        raise
      rescue JabberTee::ConfigurationError => e
        print_error(e.message)
      rescue OptionParser::InvalidOption => e
        print_error(e.message)
      rescue Exception => e
        STDERR.puts e.backtrace
        print_error(e.message)
      end
    end

    def parse!(args)
      parse_options(args)
      validate_args(args)
    end

    def parse_options(args)
      @options ||= {}
      @parsed_options ||= OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [OPTIONS] "
        opts.separator <<DESC
Description:
   This is a simple tool for reading from STDIN and writing
   to both STDOUT and a remote jabber server.  It does not handle
   reading from STDERR, so you will need to re-direct 2>&1 before
   piping it to this tool.

   The configuration file should live under ~/.jabber-tee.yml.
   Please see http://github.com/gabemc/jabber-tee for more
   information.

Options:
DESC
        opts.separator "  Connecting:"
        opts.on('-u', '--username USERNAME',
                "The user@host.org name to connect to the jabber server.") do |u|
          options[:username] = u
        end
        opts.on('-p', '--password PASSWORD',
                "The password for the user to connect to the jabber server.",
                "If not given or defined in the .jabber-tee.yml file,",
                "it will be asked during runtime.") do |p|
          options[:password] = p
        end
        opts.on('-n', '--nick NICKNAME',
                "The nickname to use when connecting to the server.") do |n|
          options[:nick] = n
        end
        opts.on('-a', '--anonymous',
                "Disregards the username information and logs in using anonymous",
                "authentication.  Either the --username or the --authentication",
                "flag are required.") do |a|
          options[:anonymous] = true
        end
        opts.on('-P', '--profile PROFILE',
                "The name of the profile, as defined in the .jabber-tee.yml",
                "file to use to connect with.") do |p|
          options[:profile] = p
        end
        opts.on('--sasl',
                "By default, the connection does not use SASL authentication.",
                "This enables SASL connections") do |s|
          options[:sasl] = true
        end
        opts.on('--digest',
                "When not using SASL, you can use the digest",
                "authentication mechanism.") do |d|
          options[:digest] = true
        end
        opts.separator ""

        opts.separator "  Output: (One required)"
        opts.on('-t', '--to TO',
                "Who to send the message to.") do |t|
          options[:to] = t
        end
        opts.on('-r', '--room ROOM',
                "The room to send the messages to.") do |r|
          options[:room] = r 
        end
        opts.separator ""

        opts.separator "  Informative:"
        opts.on('-v', '--version',
                "Show the version information") do |v|
          puts "#{File.basename($0)} version: #{JabberTee::Version.to_s}"
          exit
        end
        opts.on('-h', '--help',
                "Show this help message") do
          puts opts
          exit
        end
        opts.separator ""

      end.parse!(args)
    end

    def validate_args(args)
      if args.length > 0
        raise JabberTee::ConfigurationError.new("This command takes no extra arguments: #{args[0]}")
      end
    end

    private
    def print_error(e)
      STDERR.puts "#{File.basename($0)}: #{e}"
      STDERR.puts "#{File.basename($0)}: Try '--help' for more information"
      exit 1
    end

    JABBER_FILE = '.jabber-tee.yml'

    def load_configuration
      home = ENV['HOME'] # TODO: Windows users?
      config_file = File.join(home, JABBER_FILE)

      if File.exists?(config_file)
        reader = ConfigurationReader.new(config_file)
        if options.has_key?(:profile)
          reader.profile(options[:profile]).merge(options)
        else
          reader.profile.merge(options)
        end
      else
        Configuration.new(options)
      end
    end
  end # CLI
end
