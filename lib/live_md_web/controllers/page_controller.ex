defmodule LiveMdWeb.PageController do
  use LiveMdWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
