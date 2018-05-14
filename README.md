# [inmyti.me](http://inmyti.me/)
A mostly useless service for those wanting to share timestamps as URLs. Might become more useful in the future.

## Setup

### Install Dependencies

  * Install Elixir dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`

### Configure Geolix
inmyti.me looks up IP locations usin Geolix. You will need to set the location of the MaxMind Database GeoIP2 database within the configurations. For example:

```
config :geolix,
  databases: [
    %{
      id: :city,
      adapter: Geolix.Adapter.MMDB2,
      source: "../geoip/GeoLite2-City.mmdb"
    }
  ]
```

More information regarding Geolix configuration can be found [here](https://github.com/elixir-geolix/geolix#configuration-static).

### Starting the server:

  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.