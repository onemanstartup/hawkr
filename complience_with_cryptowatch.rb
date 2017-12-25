# frozen_string_literal: true

# Assets
# Returns all assets (in no particular order).
# Example: https://api.cryptowat.ch/assets
# Example response:
{
  "result": [ {
      "symbol": "aud",
      "name": "Australian Dollar",
      "fiat": true,
      "route": "https://api.cryptowat.ch/assets/aud"
    },
    {
      "symbol": "etc",
      "name": "Ethereum Classic",
      "fiat": false,
      "route": "https://api.cryptowat.ch/assets/etc"
    },
  ]
}

# Asset
# Returns a single asset. Lists all markets which have this asset as a base or quote.
# Example: https://api.cryptowat.ch/assets/btc

{
  "result": {
    "symbol": "btc",
    "name": "Bitcoin",
    "fiat": false,
    "markets": {
      "base": [
        {
          "exchange": "bitfinex",
          "pair": "btcusd",
          "active": true,
          "route": "https://api.cryptowat.ch/markets/bitfinex/btcusd"
        },
        {
          "exchange": "gdax",
          "pair": "btcusd",
          "route": "https://api.cryptowat.ch/markets/gdax/btcusd"
        },
      ],
      "quote": [
        {
          "exchange": "bitfinex",
          "pair": "ltcbtc",
          "active": true,
          "route": "https://api.cryptowat.ch/markets/bitfinex/ltcbtc"
        },
        {
          "exchange": "bitfinex",
          "pair": "ethbtc",
          "active": true,
          "route": "https://api.cryptowat.ch/markets/bitfinex/ethbtc"
        },
      ]
    }
  }
}

# Pairs
# Returns all pairs (in no particular order).
# Example: https://api.cryptowat.ch/pairs
# Example response:

{
  "result": [
    {
      "symbol": "xmrusd",
      "id": 82,
      "base": {
        "symbol": "xmr",
        "name": "Monero",
        "fiat": false,
        "route": "https://api.cryptowat.ch/assets/xmr"
      },
      "quote": {
        "symbol": "usd",
        "name": "United States dollar",
        "fiat": true,
        "route": "https://api.cryptowat.ch/assets/usd"
      },
      "route": "https://api.cryptowat.ch/pairs/xmrusd"
    },
    {
      "symbol": "ltcusd",
      "id": 189,
      "base": {
        "symbol": "ltc",
        "name": "Litecoin",
        "fiat": false,
        "route": "https://api.cryptowat.ch/assets/ltc"
      },
      "quote": {
        "symbol": "usd",
        "name": "United States dollar",
        "fiat": true,
        "route": "https://api.cryptowat.ch/assets/usd"
      },
      "route": "https://api.cryptowat.ch/pairs/ltcusd"
    },
  ]
}

# Pair
# Returns a single pair. Lists all markets for this pair.
# Example: https://api.cryptowat.ch/pairs/ethbtc
# Example response:

{
  "result": {
    "symbol": "ethbtc",
    "id": 23,
    "base": {
      "symbol": "eth",
      "name": "Ethereum",
      "isFiat": false,
      "route": "https://api.cryptowat.ch/assets/eth"
    },
    "quote": {
      "symbol": "btc",
      "name": "Bitcoin",
      "isFiat": false,
      "route": "https://api.cryptowat.ch/assets/btc"
    },
    "route": "https://api.cryptowat.ch/pairs/ethbtc",
    "markets": [
      {
        "exchange": "bitfinex",
        "pair": "ethbtc",
        "active": true,
        "route": "https://api.cryptowat.ch/markets/bitfinex/ethbtc"
      },
      {
        "exchange": "gdax",
        "pair": "ethbtc",
        "active": true,
        "route": "https://api.cryptowat.ch/markets/gdax/ethbtc"
      },
    ]
  }
}

# Exchanges
# Returns a list of all supported exchanges.
# Example: https://api.cryptowat.ch/exchanges
# Example response:
{
  "result": [
    {
      "symbol": "bitfinex",
      "name": "Bitfinex",
      "active": true,
      "route": "https://api.cryptowat.ch/exchanges/bitfinex"
    },
    {
      "symbol": "gdax",
      "name": "GDAX",
      "active": true,
      "route": "https://api.cryptowat.ch/exchanges/gdax"
    },
  ]
}


# Exchange
# Returns a single exchange, with associated routes.
# Example: https://api.cryptowat.ch/exchanges/kraken
# Example response:

{
  "result": {
    "id": "kraken",
    "name": "Kraken",
    "active": true,
    "routes": {
      "markets": "https://api.cryptowat.ch/markets/kraken"
    }
  }
}


# Markets
# A market is a pair listed on an exchange. For example, pair btceur on exchange kraken is a market.
# Index
# Returns a list of all supported markets.
# Example: https://api.cryptowat.ch/markets
# Example response:

{
  "result": [
    {
      "exchange": "bitfinex",
      "pair": "btcusd",
      "active": true,
      "route": "https://api.cryptowat.ch/markets/bitfinex/btcusd"
    },
    {
      "exchange": "bitfinex",
      "pair": "ltcusd",
      "active": true,
      "route": "https://api.cryptowat.ch/markets/bitfinex/ltcusd"
    },
    {
      "exchange": "bitfinex",
      "pair": "ltcbtc",
      "active": true,
      "route": "https://api.cryptowat.ch/markets/bitfinex/ltcbtc"
    },
  ]
}


# Summary

# Returns a market’s last price as well as other stats based on a 24-hour sliding window.

#     High price
#     Low price
#     % change
#     Absolute change
#     Volume

# Example: https://api.cryptowat.ch/markets/gdax/btcusd/summary

# Example response:

{
  "result": {
    "price":{
      "last": 780.31,
      "high": 790.34,
      "low": 772.76,
      "change": {
        "percentage": 0.0014373838,
        "absolute": 1.12
      }
    },
    "volume": 5345.0415
  }
}

# Trades

# Returns a market’s most recent trades, incrementing chronologically.

# Params supported:
# Param 	Description 	Format 	Example
# limit 	Limit amount of trades returned. Defaults to 50. 	Integer 	100
# since 	Only return trades at or after this time. 	UNIX timestamp 	1481663244

# Example: https://api.cryptowat.ch/markets/gdax/btcusd/trades

# Example response:

{
  "result": [
    [
      0,
      1481676478,
      734.39,
      0.1249
    ],
    [
      0,
      1481676537,
      734.394,
      0.0744
    ],
    [
      0,
      1481676581,
      734.396,
      0.1
    ],
    [
      0,
      1481676602,
      733.45,
      0.061
    ],
  ]
}

# Trades are lists of numbers in this order:

# [ ID, Timestamp, Price, Amount ]

# Note some exchanges don’t provide IDs for public trades.



# Order Book
# Returns a market’s order book.
# Example: https://api.cryptowat.ch/markets/gdax/btcusd/orderbook
# Example response:

{
  "result": {
    "asks": [
      [
        733.73,
        2.251
      ],
      [
        733.731,
        7.829
      ],
      [
        733.899,
        1.417
      ],
    ],
    "bids": [
      [
        733.62,
        0.273
      ],
    ]
}

# # [ Price, Amount ]
# Orders are lists of numbers in this order:


# OHLC

# Returns a market’s OHLC candlestick data. Returns data as lists of lists of numbers for each time period integer.

# Params supported:
# Param 	Description 	Format 	Example
# before 	Only return candles opening before this time 	UNIX timestamp 	1481663244
# after 	Only return candles opening after this time 	UNIX timestamp 	1481663244
# periods 	Only return these time periods 	Comma-separated integers 	60,180,108000

# Example: https://api.cryptowat.ch/markets/gdax/btcusd/ohlc

# Example response:

 # {
 #  "result": {
 #    "60": [
 #      [1481634360, 782.14, 782.14, 781.13, 781.13, 1.92525],
 #      [1481634420, 782.02, 782.06, 781.94, 781.98, 2.37578],
 #      [1481634480, 781.39, 781.94, 781.15, 781.94, 1.68882],
 #    ],
 #    "180": [],
 #    "300": [],
 #    "604800": []
 #  }
# }

# 1-minute candles are under the "60" key. 3-minute are "180", and so on.

# The values are in this order:

# [ CloseTime, OpenPrice, HighPrice, LowPrice, ClosePrice, Volume ]

# So for instance, we can take this string value under GDAX’s BTCUSD market for time period "14400" (4-hour):

# [ 1474747200, 604.33, 605.24, 601.08, 603.5, 436.704 ]

# This represents a 4-hour candle starting at 1474718400 (Sat, 24 Sep 2016 16:00:00 GMT) and ending at 1474747200 (Sat, 24 Sep 2016 20:00:00 GMT).

# The open price for this candle is 604.33, the high price 605.24, the low price 601.08, and the close price 603.5. The volume for this candle was 436.704 BTC.


# Aggregate Endpoints

# You can also retrieve the prices and summaries of all markets on the site in a single request. These responses are cached and may be out of date by a few seconds.

# Markets are identified by a slug, which is the exchange name and currency pair concatenated with a colon, like so:

# gdax:btcusd

# Prices

# Returns the current price for all supported markets. Some values may be out of date by a few seconds.

# Example: https://api.cryptowat.ch/markets/prices

# Example response:

{
  "result": {
    "bitfinex:bfxbtc": 0.00067133,
    "bitfinex:bfxusd": 0.52929,
    "bitfinex:btcusd": 776.73
  }
}

# Summaries

# Returns the market summary for all supported markets. Some values may be out of date by a few seconds.

# Example: https://api.cryptowat.ch/markets/summaries

# Example response:

{
  "result": {
    "bitfinex:bfxbtc": {
      "price": {
        "last": 0.00067133,
        "high": 0.0006886,
        "low": 0.00066753,
        "change": {
          "percentage": -0.02351996,
          "absolute": -1.6169972e-05
        }
      },
      "volume":84041.625
    },
    "bitfinex:bfxusd": {
    },
    "bitfinex:btcusd": {
    },
  }
}

# Our summary

{
  result: {
    "bitfinex:btc:usd": {
    }
  }
}
