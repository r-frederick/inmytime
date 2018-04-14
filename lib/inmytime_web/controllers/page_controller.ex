defmodule InmytimeWeb.PageController do
  use InmytimeWeb, :controller
  use Timex

  def index(conn, _params) do
    {:ok, datetime} = Timex.now() |> format_datetime()

    {:ok, converted} =
      Timex.now() |> Timex.to_datetime(local_from_conn(conn)) |> format_datetime()

    render(conn, "index.html", datetime: datetime, converted: converted)
  end

  def at_time(conn, %{"timestamp" => timestamp}) do
    {:ok, datetime} = Timex.parse!(timestamp, "{s-epoch}") |> format_datetime()

    {:ok, converted} =
      Timex.parse!(timestamp, "{s-epoch}")
      |> Timex.to_datetime(local_from_conn(conn))
      |> format_datetime()

    render(conn, "index.html", datetime: datetime, converted: converted)
  end

  defp format_datetime(datetime) do
    Timex.format(datetime, "{0M}/{0D}/{YYYY} @ {h12}:{m}{am} {Zabbr}")
  end

  defp local_from_conn(conn) do
    case GeoIP.lookup(conn) do
      {:ok, %GeoIP.Location{time_zone: nil}} -> "Etc/UTC"
      {:ok, %GeoIP.Location{time_zone: time_zone}} -> time_zone
      {:error, _} -> "Etc/UTC"
    end
  end
end
