defmodule VemoslaWeb.PageController do
  use VemoslaWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def index(conn, _params) do
    render(conn, :index)
  end

  def show(conn, %{"messenger" => messenger} = params) do
    render(conn, :show, messenger: messenger)
  end

  def janobourian(conn, %{"id" => id} = params) do
    render(conn, :janobourian, id: id)
  end
end
