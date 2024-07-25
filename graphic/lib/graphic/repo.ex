defmodule Graphic.Repo do
  use Ecto.Repo,
    otp_app: :graphic,
    adapter: Ecto.Adapters.Postgres
end
