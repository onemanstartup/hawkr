require 'rom-sql'
require 'rom-repository'
require 'pg'
require 'hawkr/relations/tickers'
require 'hawkr/repositories'

class RomBoot
  attr_reader :rom, :tickers_repo

  def initialize(rom_type: :sql, address: 'postgres://localhost/hawkr_db')
    @rom = ROM.container(rom_type, address) do |conf|
      conf.register_relation(Tickers)
    end
    @tickers_repo = Hawkr::TickersRepo.new(rom)
  end
end
