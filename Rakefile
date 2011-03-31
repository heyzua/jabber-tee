$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../spec", __FILE__)

require 'fileutils'
require 'rake'
require 'rubygems'
require 'rspec/core/rake_task'
require 'choosy/rake'

task :default => :spec

desc "Run the RSpec tests"
RSpec::Core::RakeTask.new :spec

task :deploy => [:gem, :clean] do
end

desc "Cleans the gem files up."
task :clean => ['gem:clean']
