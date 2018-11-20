defmodule GibberChat.Tag do
  use GibberChat.Web, :model

  schema "tags" do
    field :label, :string
    has_many :room_tags, GibberChat.RoomTag
    has_many :rooms, through: [:room_tags, :room]
    has_many :room_users, GibberChat.RoomUser
    has_many :users, through: [:room_users, :user]
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:label])
    |> validate_required([:label])
  end

  def find_tag_id(id) do
    query = from r in GibberChat.Tag, where: r.id == ^id
    GibberChat.Repo.one(query)
  end
end
