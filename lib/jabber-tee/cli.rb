require 'jabber-tee/errors'
require 'jabber-tee/executor'
require 'choosy'

module JabberTee
  class CLI
    def execute!(args)
      command.execute!(args)
    end

    def parse!(args, propagate=false)
      command.parse!(args, propagate)
    end

    def command
      Choosy::Command.new :'jabber-tee' do 
        printer :standard
        executor Executor.new

        section 'Description:' do
          para 'This is a simple tool for reading from STDIN and writing to both STDOUT and a remote jabber server.  It does not handle reading from STDERR, so you will need to re-direct 2>&1 before piping it to this tool.'
          para 'The configuration file should live under ~/.jabber-tee.yml. Please see http://github.com/gabemc/jabber-tee for more information.'
        end

        section 'Connections:' do
          string :username, "The user@host.org name used to connect to the jabber server."
          string :password, "The password for the user to connect with to the jabber server. If not given, it must be defined in your configuration file."
          string :nick, "The nickname to use when connecting to the server."
          string :Profile, "The name of the profile defined in the ~/.jabber-tee.yml or /etc/jabber-tee.yml configuration file to connect with."
          #string :anonymous, "Disregards the username information and logs in using anonymous authentication."
          #boolean_ :sasl, "By default, the connection does not use SASL authentication. This enables SASL connections."
          #boolean_ :digest, "When not using SASL, you can use the digest authentication mechanism."
        end

        section 'Ouput: (One required)' do
          string :to, "Who to send the message to."
          string :room, "The room to send the messages to."
        end

        section 'Informative:' do
          help 
          version Choosy::Version.load_from_parent
        end

        arguments do |builder|
          metaname '[-- COMMAND]'
          count :at_least => 0
        end
      end
    end
  end#CLI
end
