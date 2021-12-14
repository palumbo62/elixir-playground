# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Durangler.Repo.insert!(%Durangler.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Durangler.Countries

# Seed the 8 supported currencies
# Euro (EUR)
# UK Pound Sterling (GBP)
# Australian Dollar (AUD)
# New Zealand Dollar (NZD)
# Unites States Dollar (USD)
# Canadian Dollar (CAD)
# Swiss Franc (CHF)
# Japanese Yen (JPY)
currency_data = [
  ["European Euro", "EUR", "€"],
  ["United Kingdom Pound Sterling", "GBP", "£"],
  ["Australian Dollar", "AUD", "$"],
  ["New Zealand Dollar", "NZD", "$"],
  ["United States Dollar", "USD", "$"],
  ["Canadian Dollar", "CAD", "$"],
  ["Swiss Franc", "CHF", "CHF"],
  ["Japanese Yen", "JPY", "¥"]
]

for currency <- currency_data do
  [name, code, symbol] = currency

  {:ok, _currency} = Countries.create_currency(%{
    name: name,
    code: code,
    symbol: symbol
  })
end

# Seed the 12 supported countries
country_data = [
  ["Australia", "AUS", "AUD"],
  ["Canada", "CAN", "CAD"],
  ["France", "FRA", "EUR"],
  ["Japan", "JPN", "JPY"],
  ["Italy", "ITA", "EUR"],
  ["Liechtenstein", "LIE", "CHF"],
  ["New Zealand", "NZL", "NZD"],
  ["Portugal", "PRT", "EUR"],
  ["Spain", "ESP", "EUR"],
  ["Switzerland", "CHE", "CHF"],
  ["United Kingdom", "GBR", "GBP"],
  ["United States", "USA", "USD"]
]

for country <- country_data do
  [name, code, currency_code] = country
  currency = Countries.get_currency_by_code!(currency_code)

  {:ok, _country} = Countries.create_country(%{
    name: name,
    code: code,
    currency_id: currency.id
  })
end
