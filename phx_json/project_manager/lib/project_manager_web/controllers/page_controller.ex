defmodule ProjectManagerWeb.PageController do
  use ProjectManagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
