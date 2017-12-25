# frozen_string_literal: true

Rake.add_rakelib 'lib/tasks'

require 'rom'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    rom = ROM.container(:sql, 'postgres://postgres:postgres@db/hawkr_db')
    rom.gateways[:default]
  end
end

namespace :db_test do
  task :setup do
    rom = ROM.container(:sql, 'postgres://localhost/hawkr_db_test')
    rom.gateways[:default]
  end
end
