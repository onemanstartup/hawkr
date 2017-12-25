# frozen_string_literal: true

require 'rom-sql'
require 'rom-repository'
require 'pg'
require_relative 'hawkr/relations/tickers'
require_relative 'hawkr/repositories'

class RomBoot
  attr_reader :rom, :tickers_repo

  def initialize(rom_type: :sql, address: 'postgres://postgres:postgres@db/hawkr_db')
    address = 'postgres://postgres:postgres@localhost/hawkr_db' if ENV['TEST']

    @rom = ROM.container(rom_type, address) do |conf|
      conf.register_relation(Tickers)
    end
    @tickers_repo = Hawkr::TickersRepo.new(rom)
  end

  def self.test
    new(rom_type: :sql, address: 'postgres://localhost/hawkr_db_test')
  end
end
