defmodule InmytimeWeb.PageController do
  use InmytimeWeb, :controller
  use Timex
  alias Inmytime.Timebot

  def index(conn, _params) do
    client_tz = Timebot.geolocate_ip(conn.remote_ip)

    {:ok, digest} = Timebot.digest_now(client_tz)

    render(conn, "index.html", datetime: digest.datetime, converted: digest.converted)
  end

  def at_time(conn, %{"timestamp" => timestamp}) do
    client_tz = Timebot.geolocate_ip(conn.remote_ip)

    case Timebot.digest(timestamp, client_tz) do
      {:ok, digest} ->
        render(conn, "index.html", datetime: digest.datetime, converted: digest.converted)

      _ ->
        redirect(conn, to: "/")
    end
  end

  def at_time(conn, _) do
    redirect(conn, to: "/")
  end

  def convert_time(conn, %{"timestamp" => timestamp, "region" => region, "subregion" => subregion}) do
    timezone = Timebot.find_tz("#{region}/#{subregion}")

    case Timebot.digest(timestamp, timezone) do
      {:ok, digest} ->
        render(conn, "index.html", datetime: digest.datetime, converted: digest.converted)

      _ ->
        redirect(conn, to: "/#{timestamp}")
    end
  end

  def convert_time(conn, %{"timestamp" => timestamp, "timezone" => timezone}) do
    upcased_timezone = String.upcase timezone

    case Timebot.digest(timestamp, upcased_timezone) do
      {:ok, digest} ->
        render(conn, "index.html", datetime: digest.datetime, converted: digest.converted)

      _ ->
        redirect(conn, to: "/#{timestamp}")
    end
  end
end
