require 'jabber-tee/configuration'
require 'helpers'

module JabberTee
  describe "ConfigurationReader" do
    it "should fail when the yaml file doesn't exist" do
      attempting_to { ConfigurationReader.new('doesnt-exist.yml') }.should raise_error(ConfigurationError, /locate/)
    end

    it "should load a yaml file and pull the default profile" do
      r = ConfigurationReader.new('spec/test-config-1.yaml')
      c = r.profile

      c.username.should eql('gabe@someplace.org')
      c.room.should be(nil)
    end

    it "should be able to load sub-profiles" do
      r = ConfigurationReader.new('spec/test-config-1.yaml')
      c = r.profile('standard')

      c.room.should eql('cudos@rooms.someplace.org')
    end

    it "should fail when the profiles section doesn't exist" do
      r = ConfigurationReader.new('spec/test-config-2.yaml')
      attempting_to { r.profile('standard') }.should raise_error(ConfigurationError, /profiles/)
    end

    it "should fail when the profile doesn't exist" do
      r = ConfigurationReader.new('spec/test-config-1.yaml')
      attempting_to { r.profile('non-existant') }.should raise_error(ConfigurationError, /non-existant/)
    end
  end

  describe "The Configuration" do
    it "should initialize default values to nil" do
      c = Configuration.new
      c.username.should be(nil)
    end

    it "should set anonymous to false by default" do
      c = Configuration.new
      c.anonymous?.should be(false)
    end

    it "should se the 'in_room?' attribute to false by default" do
      c = Configuration.new
      c.in_room?.should be(false)
    end

    it "should merge options correctly" do
      options = {:username => 'gabe', :password => 'supersecret'}
      c = Configuration.new(options)
      c.username.should eql('gabe')
      c.password.should eql('supersecret')
    end

    it "should set 'anonymous' to false when a username is provided" do
      options = {:username => 'gabe' }
      c = Configuration.new(options)
      c.anonymous?.should be(false)
    end

    it "should merge options correctly more than once" do
      init = {:username => 'gabe', :password => 'supersecret'}
      options = {:room => 'rc@someplace'}
      c = Configuration.new(init)
      c.merge(options)
      c.in_room?.should be(true)
      c.room.should eql('rc@someplace')
    end

    it "should set the 'to' field correctly" do
      c = Configuration.new
      c.merge({:to => 'to-me'})
      c.in_room?.should be(false)
      c.to.should eql('to-me')
    end
  end
end
