defmodule InmytimeWeb.PageController do
  use InmytimeWeb, :controller
  use Timex

  require Logger

  def index(conn, _params) do
    {:ok, datetime} = Timex.now() |> format_datetime()

    {:ok, converted} =
      Timex.now() |> Timex.to_datetime(local_from_conn(conn)) |> format_datetime()

    render(conn, "index.html", datetime: datetime, converted: converted)
  end

  def at_time(conn, %{"timestamp" => timestamp}) do
    case Integer.parse(timestamp) do
      {_, ""} ->
        parsed_time = Timex.parse!(timestamp, "{s-epoch}")

        {:ok, datetime} = parsed_time |> format_datetime()

        {:ok, converted} =
          parsed_time
          |> Timex.to_datetime(local_from_conn(conn))
          |> format_datetime()

        render(conn, "index.html", datetime: datetime, converted: converted)

      _ ->
        redirect(conn, to: "/")
    end
  end

  def at_time(conn, _) do
    redirect(conn, to: "/")
  end

  defp format_datetime(datetime) do
    Timex.format(datetime, "{0M}/{0D}/{YYYY} @ {h12}:{m}{am} {Zabbr}")
  end

  defp local_from_conn(conn) do
    Logger.info("#{inspect(conn.remote_ip)}")

    case Geolix.lookup(conn.remote_ip) do
      %{city: %{location: %{time_zone: tz}}} -> tz
      _ -> "Etc/UTC"
    end
  end
end
