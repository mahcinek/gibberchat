defmodule GibberChat.Repo.Migrations.CreateBlockage do
  use Ecto.Migration

  def change do
    create table(:blockages) do
      add :user_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:blockages, [:user_id])
    create index(:blockages, [:room_id])
  end
end
