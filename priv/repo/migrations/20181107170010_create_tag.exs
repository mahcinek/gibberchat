defmodule GibberChat.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :label, :text

      timestamps()
    end
  end
end
