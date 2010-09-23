require 'jabber-tee/errors'

require 'rubygems'
require 'xmpp4r'
require 'xmpp4r/muc'

module JabberTee
  class Client
    attr_reader :config, :client

    def initialize(config)
      @config = config
      @client = Jabber::Client.new(Jabber::JID.new("#{config.username}/#{config.nick}"))
      client.connect
      client.auth(config.password)

      if config.in_room?
        @muc = Jabber::MUC::SimpleMUCClient.new(client)
        @muc.join(Jabber::JID.new("#{config.room}/#{config.nick}"))
      end
    end

    def pump!
      if $stdin.tty?
        $STDERR.puts "Unable to pipe jabber-tee from a TTY"
        exit(1)
      else
        $stdin.each do |line|
          line.chomp!
          say(line)
          puts line
        end
      end
    end

    def say(message)
      if config.in_room?
        @muc.say(message)
      else
        msg = Jabber::Message.new(config.to, message)
        msg.type = :chat
        client.send(msg)
      end
    end
  end
end
