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

  test "GET /malformedorinvalidinput redirects to the current timestamp", %{conn: conn} do
    conn = get conn, "/malformedorinvalidinput"

    assert html_response(conn, 302)
  end

  test "GET /now returns a 200", %{conn: conn} do
    conn = get conn, "/now"

    assert html_response(conn, 200)
  end

  test "GET /1526432420/in/pdt returns a timestamp represented in both UTC and PDT", %{conn: conn} do
    conn = get conn, "/1526432420/in/PDT"

    assert html_response(conn, 200) =~ "05/15/2018 @ 6:00pm PDT"
  end

  test "GET /1526432420/in/America/New_York returns a timestamp represented in both UTC and EDT", %{conn: conn} do
    conn = get conn, "/1526432420/in/America/New_York"

    assert html_response(conn, 200) =~ "05/15/2018 @ 9:00pm EDT"
  end
end
