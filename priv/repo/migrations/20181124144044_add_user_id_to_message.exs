defmodule GibberChat.Repo.Migrations.AddUserIdToMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
