require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "after_commit"
    gem.summary = %Q{after_commit callback for ActiveRecord}
    gem.description = %Q{
      A Ruby on Rails plugin to add an after_commit callback. This can be used to trigger things only after the entire transaction is complete.
    }
    gem.email = "yipdw@northwestern.edu"
    gem.homepage = "http://github.com/yipdw/after_commit"
    gem.authors = ["Nick Muerdter", "David Yip"]
    gem.add_development_dependency "thoughtbot-shoulda"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end


desc 'Default: run unit tests.'
task :default => :test

desc 'Test the after_commit plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the after_commit plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AfterCommit'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
