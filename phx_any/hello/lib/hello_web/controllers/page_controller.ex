defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  plug(:tester)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  defp tester(conn, _params) do
    IO.puts("I am middleware!")
    conn
  end
end
