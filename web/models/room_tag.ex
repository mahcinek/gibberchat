defmodule GibberChat.RoomTag do
  use GibberChat.Web, :model

  schema "room_tags" do
    belongs_to :room, GibberChat.Room, foreign_key: :room_id
    belongs_to :tag, GibberChat.Tag, foreign_key: :tag_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
