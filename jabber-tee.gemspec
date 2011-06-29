require 'rubygems'
require 'rake'

Gem::Specification.new do |gem|
  gem.name           = 'jabber-tee'
  gem.version        = begin
                         require 'choosy/version'
                         Choosy::Version.load_from_lib.to_s
                       rescue LoadError
                         '0'
                       end
  gem.executables    = %W{jabber-tee}
  gem.summary        = 'Simple command line utility for piping the output from one command to both the console and a remote jabber server.'
  gem.description    = "Installs the 'jabber-tee' utility for sending messages to a remote jabber server.  Instead of a standard client, it reads from standard in and continues to write to the console."
  gem.email          = ['madeonamac@gmail.com']
  gem.authors        = ['Gabe McArthur']
  gem.homepage       = 'http://github.com/gabemc/jabber-tee'
  gem.files          = FileList["[A-Z]*", "{bin,lib,spec}/**/*"]
   
  gem.add_dependency    'highline',   '>=1.5.2'
  gem.add_dependency    'xmpp4r',     '>=0.5'
  gem.add_dependency    'choosy',     '>=0.4.8'
   
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'autotest'
  gem.add_development_dependency 'autotest-notification'
end
