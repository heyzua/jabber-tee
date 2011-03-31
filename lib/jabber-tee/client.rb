require 'jabber-tee/errors'
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

    def say(message)
      message.chomp!
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
