defmodule GibberChat.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :title, :text
      add :access_token, :text
      add :open, :boolean, default: true, null: true
      add :save_on, :boolean, default: false, null: true
      add :auth_on, :boolean, default: false, null: true
      add :options, :text

      timestamps()
    end

    create unique_index(:rooms, [:access_token])
  end
end
