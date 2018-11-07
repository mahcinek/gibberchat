defmodule GibberChat.Repo.Migrations.CreateUserTag do
  use Ecto.Migration

  def change do
    create table(:user_tags) do
      add :user_id, references(:users, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps()
    end

    create index(:user_tags, [:user_id])
    create index(:user_tags, [:tag_id])
  end
end
