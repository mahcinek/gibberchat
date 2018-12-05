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

    def find_blockage_id(id) do
    query = from r in GibberChat.Blockage, where: r.id == ^id
    GibberChat.Repo.one(query)
  end
  def find_u_r(user_id, room_id) do
    query = from r in GibberChat.Blockage, where: r.user_id == ^user_id and r.room_id == ^room_id
    GibberChat.Repo.one(query)
  end

end
