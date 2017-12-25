# frozen_string_literal: true

Rake.add_rakelib 'lib/tasks'

require 'rom'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    rom = if ENV['TEST']
            ROM.container(:sql, 'postgres://postgres:postgres@localhost/hawkr_db')
          else
            ROM.container(:sql, 'postgres://postgres:postgres@db/hawkr_db')
          end
    rom.gateways[:default]
  end
end

namespace :db_test do
  task :setup do
    rom = ROM.container(:sql, 'postgres://postgres:postgres@localhost/hawkr_db_test')
    rom.gateways[:default]
  end
end
