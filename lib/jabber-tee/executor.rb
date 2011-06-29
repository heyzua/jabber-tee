require 'jabber-tee/errors'
require 'jabber-tee/client'
require 'jabber-tee/configuration'
require 'jabber-tee/console'
require 'choosy/terminal'
require 'thread'

module JabberTee
  class Executor
    include Choosy::Terminal

    JABBER_FILE_LOCATIONS = [
      File.join(ENV['HOME'], '.jabber-tee.yml'),
      '/etc/jabber-tee.yml'
    ]

    def execute!(args, options)
      config = load_configuration(options)

      queue = Queue.new
      input_count = 0
      output_count = 0
      code = 0

      producer = Thread.new do
        console = Console.new(args)
        code = console.write_to do |line|
          queue.push(line)
          input_count += 1
        end
      end

      consumer = Thread.new do
        client = Client.new(config)
        while !queue.empty? && output_count < input_count
          client.say(que.pop)
          output_count += 1
        end
      end
      consumer.join

      exit code
    end

    private
    def load_configuration(options)
      config = nil
      begin
        config_file = JABBER_FILE_LOCATIONS.select {|l| File.exists?(l)}

        if !config_file.nil? && File.exists?(config_file[0])
          reader = ConfigurationReader.new(config_file[0])
          config = reader.profile(options[:Profile]).merge(options)
        else
          config = Configuration.new(options)
        end
      rescue JabberTee::ConfigurationError => e
        die e.message
      end

      if config.destination_missing?
        die "Either the --to or --room flag is required."
      end

      config
    end
  end
end
