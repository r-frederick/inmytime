defmodule InmytimeWeb.Plugs.ForwardedFor do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    case get_req_header(conn, "x-forwarded-for") do
      [] -> conn
      [forwarded_for] ->
        case :inet_parse.address(to_charlist(forwarded_for)) do
          {:ok, forwarded_for} -> %{conn | remote_ip: forwarded_for}
          _ -> conn
        end
    end
  end
end
