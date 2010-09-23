require 'jabber-tee/errors'

require 'rubygems'
require 'highline/import'
require 'yaml'

module JabberTee

  class ConfigurationReader
    def initialize(yaml_file)
      if !File.exists?(yaml_file)
        raise JabberTee::ConfigurationError.new("Unable to locate the configuration file.")
      end

      yaml = nil
      file = File.open(yaml_file) {|f| yaml = f.read }
      @config = YAML::load(yaml)
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
        if config.nil?
          raise JabberTee::ConfigurationError.new("Unable to load the #{name} profile from your home configuration.")
        end
        config.merge(profile)
      end
    end
  end

  class Configuration
    ATTRIBUTES = ['username', 'nick', 'password', 'anonymous', 'sasl', 'digest', 'room', 'to']

    attr_reader :username, :nick, :to, :room

    def initialize(options=nil)
      if !options.nil?
        merge(options)
      end
    end

    def merge(options)
      ATTRIBUTES.each do |attr|
        if options.has_key?(attr.to_sym) || options.has_key?(attr)
          value = options[attr.to_sym] || options[attr]
          instance_variable_set("@#{attr}", value)
        end
      end
      self
    end

    def password
      if @password.nil?
        @password = ask("#{username}: password: ") {|q| q.echo = false }
      end
      @password
    end

    def anonymous?
      !@anonymous.nil? && username.nil?
    end

    def sasl?
      !@sasl.nil?
    end

    def digest?
      !@digest.nil?
    end

    def in_room?
      !@room.nil?
    end

    def destination_missing?
      @room.nil? && @to.nil?
    end

    def to_s
      "<JabberTee::Configuration{:username => '#{username}', :room => '#{room}', :to => '#{to}', :anonymous => #{anonymous?}, :sasl => #{sasl?}}>"
    end
  end
end
