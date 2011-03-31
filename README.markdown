# Jabber TEE

This is a simple command line tool for writing input from the client to a remote jabber server and outputting to the console.

# Installing

The command line tool can be installed with:

    gem install jabber-tee

# Using

The general idea is that you can pipe anything from the console into this, and it will be sent to the remote jabber server:

    cat huge_text_file.txt | jabber-tee -u peon@bigcorp.com --room working-hard@rooms.bigcorp.com --nick 'Worker Drone'

or

    echo "I am $(whoami) at $(hostname)" | jabber-tee --to somebody@somewhere.com

Alternatively, you can supply a list of arguments that will be run as a command, which is essentially equivalent:

    jabber-tee --to somebody@somewhere.com -- echo "I am $(whoami) at $(hostname)"
  
# Configuration

Because entering the same information on the command line for this thing can be tedious, you can create a ~/.jabber-tee.yml file that fills in all of the basic configuration.  This file also allows you to further customize the output that is sent to the jabber server.

An example configuration file:

    # Global configuration values:
    username: my.name@jabber.org
    nick: 'Gabe'

    # Individual profiles that customize global variables
    profiles:
        new-hotness:
            # Uses the standard username, above
            nick: 'Mr. Super Cool'
            room: 'HipCentral'
            password: 'secret'
    
        somebody.else:
            username: supercooldude@gmail.com
            nick: 'Rocksteady Gabe'
            to: somebody.else@gmail.com

        work-stuff:
            username: peon@bigcorp.com
            nick: 'Worker Drone'
            room: working-hard@rooms.bigcorp.com

You can then activate these individual profiles from the command line with the '-P' flag.  So, the above command could be replaced with:

    cat huge_text_file.txt | jabber-tee -P work-stuff

