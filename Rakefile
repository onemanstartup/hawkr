require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'mutant'

RSpec::Core::RakeTask.new(:spec)

task :fuzz do
  status = Mutant::CLI.run(%w[--include lib --require hawkr --use rspec Hawkr])

  if status
    puts 'Mutant task was successful'
  else
    puts 'Mutant task was not successful'
  end
end

task default: %i[spec fuzz]

begin
  require 'rubocop/rake_task'

  Rake::Task[:default].enhance [:rubocop]

  RuboCop::RakeTask.new do |task|
    task.options << '--display-cop-names'
  end
rescue LoadError
  raise LoadError
end
