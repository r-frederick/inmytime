defmodule InmytimeWeb.PageController do
  use InmytimeWeb, :controller
  use Timex
  alias Inmytime.Timebot

  def index(conn, _params) do
    client_tz = Timebot.find_tz(conn.remote_ip)

    {:ok, digest} = Timebot.digest_now(client_tz)

    render(conn, "index.html", datetime: digest.datetime, converted: digest.converted)
  end

  def at_time(conn, %{"timestamp" => timestamp}) do
    client_tz = Timebot.find_tz(conn.remote_ip)

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
    case Timebot.digest(timestamp, "#{region}/#{subregion}") do
      {:ok, digest} ->
        render(conn, "index.html", datetime: digest.datetime, converted: digest.converted)

      _ ->
        redirect(conn, to: "/")
    end
  end

  def convert_time(conn, %{"timestamp" => timestamp, "timezone" => timezone}) do
    case Timebot.digest(timestamp, timezone) do
      {:ok, digest} ->
        render(conn, "index.html", datetime: digest.datetime, converted: digest.converted)

      _ ->
        redirect(conn, to: "/")
    end
  end
end
