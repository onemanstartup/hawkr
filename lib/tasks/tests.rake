# frozen_string_literal: true

begin
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
rescue LoadError
  puts 'You are running in wrong environment or forget to install gems'
end


task default: %i[spec]

begin
  require 'rubocop/rake_task'

  Rake::Task[:default].enhance [:rubocop]

  RuboCop::RakeTask.new do |task|
    task.options << '--display-cop-names'
  end
rescue LoadError
  puts 'You are running in wrong environment or forget to install gems'
end

