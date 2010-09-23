$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../spec", __FILE__)

require 'fileutils'
require 'rake'
require 'rubygems'
require 'spec/rake/spectask'
require 'jabber-tee/version'

task :default => :spec

desc "Run the RSpec tests"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['-b', '-c', '-f', 'p']
  t.fail_on_error = false
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name           = 'jabber-tee'
    gem.version        = JabberTee::Version.to_s
    gem.executables    = %W{jabber-tee}
    gem.summary        = 'Simple command line utility for piping the output from one command to both the console and a remote jabber server.'
    gem.description    = "Installs the 'jabber-tee' utility for sending messages to a remote jabber server.  Instead of a standard client, it reads from standard in and continues to write to the console."
    gem.email          = ['madeonamac@gmail.com']
    gem.authors        = ['Gabe McArthur']
    gem.homepage       = 'http://github.com/gabemc/jabber-tee'
    gem.files          = FileList["[A-Z]*", "{bin,lib,spec}/**/*"]
    
    gem.add_dependency    'highline',   '>=1.5.2'
    gem.add_dependency    'xmpp4r',     '>=0.5'
    
    gem.add_development_dependency 'rspec', '>=1.3.0'
  end
rescue LoadError
  puts "Jeweler or dependencies are not available.  Install it with: sudo gem install jeweler"
end

desc "Deploys the gem to rubygems.org"
task :gem => :release do
  system("gem build jabber-tee.gemspec")
  system("gem push jabber-tee-#{JabberTee::Version.to_s}.gem")
end

desc "Does the full release cycle."
task :deploy => [:gem, :clean] do
end

desc "Cleans the gem files up."
task :clean do
  FileUtils.rm(Dir.glob('*.gemspec'))
  FileUtils.rm(Dir.glob('*.gem'))
end
