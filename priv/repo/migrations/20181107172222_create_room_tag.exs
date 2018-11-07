defmodule GibberChat.Repo.Migrations.CreateRoomTag do
  use Ecto.Migration

  def change do
    create table(:room_tags) do
      add :room_id, references(:rooms, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps()
    end

    create index(:room_tags, [:room_id])
    create index(:room_tags, [:tag_id])
  end
end
