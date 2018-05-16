use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :inmytime, InmytimeWeb.Endpoint,
  http: [port: 4001],
  server: false

# Geolix Configuration
config :geolix,
  databases: [
    %{
      id: :city,
      adapter: Geolix.Adapter.MMDB2,
      source: "../geoip/GeoLite2-City.mmdb"
    }
  ]

# Print only warnings and errors during test
config :logger, level: :warn
