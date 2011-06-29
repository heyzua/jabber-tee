require 'jabber-tee/errors'
require 'choosy/terminal'

module JabberTee
  class Console
    include Choosy::Terminal

    def initialize(args)
      @command = format_command(args)
      if @command && stdin?
        die "Cannot both execute command and read from STDIN"
      elsif @command.nil? && !stdin?
        die "Unable to read from STDIN"
      end
    end

    def write_to(&block)
      pipe_in(@command) do |line|
        $stdout.puts line
        yield line
      end.to_i # Returns the exit code
    end

    private
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
  end
end
