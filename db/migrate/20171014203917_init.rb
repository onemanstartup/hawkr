# frozen_string_literal: true

ROM::SQL.migration do
  up do
    run 'CREATE EXTENSION "uuid-ossp"'
    # CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
    run 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;'

    create_table :tickers do
      # column :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
      column :time,       DateTime,   null: false, default: Sequel.function(:now)
      column :unique_ticker, String,  null: false
      column :market,     String,     null: false
      column :currency,   String,     null: false
      column :ticker,     String,     null: false
      column :price,      BigDecimal, null: false
      column :bid,        BigDecimal
      column :ask,        BigDecimal
      column :low_24h,    BigDecimal
      column :high_24h,   BigDecimal
      column :avg_24h,    BigDecimal
      column :volume_24h, BigDecimal
      column :volume_30d, BigDecimal
    end

    # TODO: SELECT create_hypertable('tickers', 'time');
    run "SELECT create_hypertable('tickers', 'time');"
    puts 'Migration complete'
  end

  down do
    drop_table(:tickers)
    run 'DROP EXTENSION "uuid-ossp"'
  end
end
