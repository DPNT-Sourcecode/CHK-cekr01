require 'rake/testtask'
require 'rspec/core/rake_task'

#~~~~~~~ Test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "{,/*,/*/*}/**/*_spec.rb"
  t.rspec_opts = "--require spec_helper"
end

task default: [:spec, :test]

#~~~~~~~~~ Play

desc 'Run the client'
task :run do
  sh "ruby -I lib lib/send_command_to_server.rb #{ENV['action']}"
end