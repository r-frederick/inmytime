defmodule Inmytime.Timebot do
  def digest(timestamp, timezone) do
    case Integer.parse(timestamp) do
      {_, ""} ->
        parsed_time = Timex.parse!(timestamp, "{s-epoch}")

        {:ok, datetime} = parsed_time |> format

        {:ok, converted} =
          parsed_time
          |> Timex.to_datetime(timezone)
          |> format

        {:ok, %{datetime: datetime, converted: converted}}

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

  def find_tz({_, _, _, _} = ip) do
    case Geolix.lookup(ip) do
      %{city: %{location: %{time_zone: tz}}} -> tz
      _ -> "Etc/UTC"
    end
  end

  def format(datetime) do
    Timex.format(datetime, "{0M}/{0D}/{YYYY} @ {h12}:{m}{am} {Zabbr}")
  end
end
