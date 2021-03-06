defmodule Inmytime.Timebot do
  def digest(timestamp, timezone) do
    case Integer.parse(timestamp) do
      {_, ""} ->
        parsed_time =
          timestamp
          |> String.replace("-", "") # Get 'absolute' value of timestamp string
          |> String.slice(0, 11) # Truncate timestamp as Timex might have issues with long timestamps
          |> Timex.parse!("{s-epoch}")

        with {:ok, datetime} <- format(parsed_time),
             {:ok, converted} <- format(Timex.to_datetime(parsed_time, timezone))
        do
          {:ok, %{datetime: datetime, converted: converted}}
        else
          _ -> {:error}
        end

      _ ->
        {:error}
    end
  end

  def digest_now(timezone) do
    {:ok, datetime} = Timex.now() |> format()

    {:ok, converted} =
      Timex.now() |> Timex.to_datetime(timezone) |> format()

    {:ok, %{datetime: datetime, converted: converted}}
  end

  def geolocate_ip({_, _, _, _} = ip) do
    case Geolix.lookup(ip) do
      %{city: %{location: %{time_zone: tz}}} -> tz
      _ -> "Etc/UTC"
    end
  end

  def format(datetime) do
    Timex.format(datetime, "{0M}/{0D}/{YYYY} @ {h12}:{m}{am} {Zabbr}")
  end

  def find_tz(timezone) do
    Timex.timezones
      |> Enum.find(fn tz -> String.downcase(tz) == String.downcase(timezone) end)
  end
end
