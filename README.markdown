# Jabber TEE

This is a simple command line tool for writing input from the client to a remote jabber server and outputting to the console.

# Installing

The command line tool can be installed with:

    gem install jabber-tee

# Using

The general idea is that you can pipe anything from the console into this, and it will be sent to the remote jabber server:

    cat huge_text_file.txt | jabber-tee -s jabber.google.com -u madeonamac@gmail.com --to somebody.else@gmail.com
  
# Configuration

Because entering the same information on the command line for this thing can be tedious, you can create a ~/.jabber-tee.yml file that fills in all of the basic configuration.  This file also allows you to further customize the output that is sent to the jabber server.

An example configuration file:

    # Global configuration values:
    username: my.name@jabber.org
    server: jabber.org
    colors: 
        stderr: red

    # Individual profiles that customize global variables    
    profiles:
        somebody.else:
            username: madeonamac@gmail.com
            to: somebody.else@gmail.com
            server: jabber.google.com
            colors:
                stdout:  #F7F7F7
                stderr:  #ECECEC
            
        work-stuff:
            server: jabber.bigcorp.com
            username: peon@bigcorp.com
            sasl: true
            # Uses the global stderr colors defined above

You can then activate these individual profiles from the command line with the '-P' flag.  So, the above command could be replaced with:

    cat huge_text_file.txt | jabber-tee -P somebody.else

