$:.unshift("lib")

require "bundler/gem_tasks"
require "rake/testtask"
require "queue_classic-later"

task :default => ['test']
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['spec/**/*_test.rb']
  t.verbose = true
  t.warning = true
end
