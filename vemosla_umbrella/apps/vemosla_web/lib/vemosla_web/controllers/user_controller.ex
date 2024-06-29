defmodule VemoslaWeb.UserController do
  use VemoslaWeb, :controller

  def index(conn, params) do
    IO.puts("""
    Params inside /users: #{inspect(params)}
    """)
    render(conn, :index, params: params)
  end

end
