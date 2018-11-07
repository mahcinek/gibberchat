defmodule GibberChat.Repo.Migrations.AddAccessToken do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :access_token, :text
    end
    create unique_index(:users, [:access_token])
    create unique_index(:room_users, [:auth_token])
  end
end
