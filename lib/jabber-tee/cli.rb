require 'optparse'
require 'jabber-tee/errors'
require 'jabber-tee/version'

module JabberTee
  class CLI
    attr_reader :options, :args
    attr_accessor :check_home_config

    def initialize(args)
      @args = args
      @check_home_configs = true
    end

    def execute!
      parse!(@args.dup)

      # TODO
    end

    def parse!(args)
      begin
        parse_options(args)
        if check_home_config
          merge_options
        end
        validate_args(args)
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

    def parse_options(args)
      @options ||= {}
      @parsed_options ||= OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [OPTIONS] "
        opts.separator <<DESC
Description:
   This is a simple tool for reading from STDIN and writing
   to both STDOUT and a remote jabber server.  By default,
   STDERR is colored red when passed to the jabber server,
   but this can be changed by the configuration file.

   The configuration file should live under ~/.jabber-tee.yml.
   Please see http://github.com/gabemc/jabber-tee for more
   information.

Options:
DESC
        opts.separator "   Connecting:"
        opts.on('-s', '--server JABBER',
                "The jabber server to connect to.  This is required.") do |s|
          options[:server] = s
        end
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

        opts.separator "   Output:"
        opts.on('-t', '--to TO',
                "Who to send the message to.  This is required.") do |t|
          options[:to] = t
        end
        opts.on('--nocolor',
                "Don't color the output to the jabber server.") do |n|
          options[:nocolor] = true
        end
        opts.on('--stderr COLOR',
                "Colors the STDERR stream to the jabber server.") do |s|
          options[:stderr] = s
        end
        opts.on('--stdout COLOR',
                "Colors the stdout stream to the jabber server.") do |s|
          options[:stdout] = s
        end
        opts.separator ""

        opts.separator "   Informative:"
        #opts.on('-d', '--debug', 
        #        "Prints extra debug information") do |d|
        #  options[:debug] = d
        #end
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

    def merge_options
      raise Exception.new("not done")
    end

    def validate_args(args)
      if args.length > 0
        raise JabberTee::ConfigurationError.new("This command takes no extra arguments: #{args[0]}")
      end

      if !options[:username] && !options[:anonymous] && !options[:profile]
        raise JabberTee::ConfigurationError.new("Either the username or anonymous authentication are required if no profile is specified.")
      end
      
      if !options[:to]
        raise JabberTee::ConfigurationError.new("The --to flag to send the message to is required.")
      end
    end

    private
    def print_error(e)
      STDERR.puts "#{File.basename($0)}: #{e}"
      STDERR.puts "#{File.basename($0)}: Try '--help' for more information"
      exit 1
    end
  end # CLI
end
