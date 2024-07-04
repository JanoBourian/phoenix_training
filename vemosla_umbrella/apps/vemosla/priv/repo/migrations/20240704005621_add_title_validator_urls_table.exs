defmodule Vemosla.Repo.Migrations.AddTitleValidatorUrlsTable do
  use Ecto.Migration

  def change do

    create unique_index(:urls, [:title])
    create unique_index(:urls, [:link])
  end
end
