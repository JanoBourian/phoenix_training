defmodule VemoslaWeb.UserController do
  use VemoslaWeb, :controller

  def index(conn, params) do
    IO.puts("""
    Params inside /users: #{inspect(params)}
    """)
    # text(conn, "This a text using Elixir")
    render(conn, :index, params: params)
  end

end
