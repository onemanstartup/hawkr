# frozen_string_literal: true

class Tickers < ROM::Relation[:sql]
  schema(:tickers) do
    attribute :market,     Types::Coercible::String
    attribute :currency,   Types::Coercible::String
    attribute :ticker,     Types::Coercible::String
    attribute :price,      Types::Form::Decimal
    attribute :bid,        Types::Form::Decimal
    attribute :ask,        Types::Form::Decimal
    attribute :low_24h,    Types::Form::Decimal
    attribute :high_24h,   Types::Form::Decimal
    attribute :avg_24h,    Types::Form::Decimal
    attribute :volume_24h, Types::Form::Decimal
    attribute :volume_30d, Types::Form::Decimal
  end
end
