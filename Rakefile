# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'mutant'

RSpec::Core::RakeTask.new(:spec)

task :fuzz do
  status = Mutant::CLI.run(%w[--include lib --require hawkr --use rspec Hawkr --use rspec Markets])

  if status
    puts 'Mutant task was successful'
  else
    puts 'Mutant task was not successful'
  end
end

task default: %i[spec]

begin
  require 'rubocop/rake_task'

  Rake::Task[:default].enhance [:rubocop]

  RuboCop::RakeTask.new do |task|
    task.options << '--display-cop-names'
  end
rescue LoadError
  raise LoadError
end

require 'rom'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    rom = ROM.container(:sql, 'postgres://localhost/hawkr_db')
    rom.gateways[:default]
  end
end

namespace :db_test do
  task :setup do
    rom = ROM.container(:sql, 'postgres://localhost/hawkr_db_test')
    rom.gateways[:default]
  end
end
