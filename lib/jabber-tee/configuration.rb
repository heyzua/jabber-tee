require 'jabber-tee/errors'
require 'highline/import'
require 'yaml'

module JabberTee
  class ConfigurationReader
    def initialize(yaml_file)
      if !File.exists?(yaml_file)
        raise JabberTee::ConfigurationError.new("Unable to locate the configuration file.")
      end

      @config = YAML::load_file(yaml_file)
    end
    
    def profile(name=nil)
      if name.nil?
        Configuration.new(@config)
      else
        config = Configuration.new(@config)
        profiles = @config['profiles']
        if profiles.nil?
          raise JabberTee::ConfigurationError.new("Unable to load an profiles from your home configuration.")
        end
        profile = profiles[name]
        if profile.nil?
          raise JabberTee::ConfigurationError.new("Unable to load the '#{name}' profile from your home configuration.")
        end
        config.merge(profile)
      end
    end
  end

  class Configuration
    ATTRIBUTES = [:username, :nick, :password, :anonymous, :room, :to]

    attr_reader :username, :nick, :to, :room

    def initialize(options=nil)
      @username = @nick = @to = @room = @anonymous = @password = nil
      if !options.nil?
        merge(options)
      end
    end

    def merge(options=nil)
      return self if options.nil?
      ATTRIBUTES.each do |attr|
        value = options[attr] || options[attr.to_s]
        instance_variable_set("@#{attr}", value) if value
      end
      self
    end

    def password
      @password ||= ask("#{username}: password: ") {|q| q.echo = false }
    end

    def anonymous?
      !@anonymous.nil? && username.nil?
    end

    def in_room?
      !@room.nil?
    end

    def destination_missing?
      @room.nil? && @to.nil?
    end
  end
end
