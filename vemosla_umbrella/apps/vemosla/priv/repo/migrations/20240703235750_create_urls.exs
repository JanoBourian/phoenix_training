defmodule Vemosla.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :link, :string
      add :title, :string

      timestamps()
    end
  end
end
