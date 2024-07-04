defmodule Vemosla.Repo.Migrations.AddFieldValidatorUrlsTable do
  use Ecto.Migration

  def change do

    create unique_index(:urls, [:link, :title])
  end
end
