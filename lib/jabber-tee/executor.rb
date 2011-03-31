require 'jabber-tee/errors'
require 'jabber-tee/client'
require 'jabber-tee/configuration'
require 'choosy/terminal'

module JabberTee
  class Executor
    include Choosy::Terminal

    JABBER_FILE_LOCATIONS = [
      File.join(ENV['HOME'], '.jabber-tee.yml'),
      '/etc/jabber-tee.yml'
    ]

    def execute!(args, options)
      command = format_command(args)
      if command && stdin?
        die "Cannot both execute command and read from STDIN"
      elsif command.nil? && !stdin?
        die "Unable to read from STDIN"
      end

      client = create_client(options)
      code = pipe_in(command) do |line|
        client.say(line)
        puts line
      end

      exit code.to_i
    end

    private
    def create_client(options)
      config = load_configuration(options)
      if config.destination_missing?
        die "Either the --to or --room flag is required."
      end

      Client.new(config)
    end

    def format_command(args)
      if args.length > 0 
        if !command_exists?(args[0])
          die "Not a recognized command: #{args[0]}"
        else
          args.join(' ')
        end
      else
        nil
      end
    end

    def load_configuration(options)
      begin
        config_file = JABBER_FILE_LOCATIONS.select {|l| File.exists?(l)}

        if !config_file.nil? && File.exists?(config_file[0])
          reader = ConfigurationReader.new(config_file[0])
          reader.profile(options[:Profile]).merge(options)
        else
          Configuration.new(options)
        end
      rescue JabberTee::ConfigurationError => e
        die e.message
      end
    end
  end
end
