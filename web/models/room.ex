defmodule GibberChat.Room do
  use GibberChat.Web, :model

  schema "rooms" do
    field :title, :string
    field :access_token, :string
    field :open, :boolean, default: true
    field :save_on, :boolean, default: false
    field :auth_on, :boolean, default: false
    field :options, :string
    has_many :room_tags, GibberChat.RoomTag
    has_many :tags, through: [:room_tags, :tag]
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :access_token, :open, :save_on, :auth_on, :options])
    |> validate_required([:title, :save_on, :auth_on])
    |> unique_constraint(:access_token)
  end

  def open_rooms() do
    query = from r in GibberChat.Room, where: r.open == true, preload: [:tags]
    GibberChat.Repo.all(query)
  end
  def all_rooms() do
    query = from r in GibberChat.Room, preload: [:tags]
    GibberChat.Repo.all(query)
  end
  def find_room(token) do
    query = from r in GibberChat.Room, where: r.access_token == ^token
    GibberChat.Repo.one(query)
  end
  def find_room_id(id) do
    query = from r in GibberChat.Room, where: r.id == ^id
    GibberChat.Repo.one(query)
  end
end
