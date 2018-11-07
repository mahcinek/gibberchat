defmodule GibberChat.Blockage do
  use GibberChat.Web, :model

  schema "blockages" do
    belongs_to :user, GibberChat.User, foreign_key: :user_id
    belongs_to :room, GibberChat.Room, foreign_key: :room_id

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
