defmodule InmytimeWeb.PageControllerTest do
  use InmytimeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "inmyti.me"
  end

  test "GET /1526432420 returns a timestamp represented in both UTC and CDT", %{conn: conn} do
    conn = conn
    |> Map.put(:remote_ip, {192, 227, 139, 106}) # Assign an IP in CDT timezone
    |> get("/1526432420")

    assert html_response(conn, 200) =~ "05/16/2018 @ 1:00am UTC"
    assert html_response(conn, 200) =~ "05/15/2018 @ 8:00pm CDT"
  end

  test "GET /malformedorinvalideinput redirects to the current timestamp", %{conn: conn} do
    conn = get conn, "/malformedorinvalidinput"

    assert html_response(conn, 302)
  end
end
