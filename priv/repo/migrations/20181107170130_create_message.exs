defmodule GibberChat.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text
      add :options, :text
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:room_id])
  end
end
