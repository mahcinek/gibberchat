defmodule GibberChat.User do
  use GibberChat.Web, :model

  schema "users" do
    field :nick, :string
    field :options, :string
    field :admin, :boolean, default: false
    field :access_token, :string
    has_many :user_tags, GibberChat.UserTag
    has_many :tags, through: [:user_tags, :tag]
    has_many :room_users, GibberChat.RoomUser
    has_many :rooms, through: [:room_users, :room]
    has_many :messages, GibberChat.Message
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nick, :options, :admin, :access_token])
    |> validate_required([:nick, :admin])
    |> unique_constraint(:nick, name: :users_nick_index)
  end

  def auth_adm_helper(conn,token) do
    resp = auth_admin(token)
    IO.inspect resp
    %{res: r, status: s} = resp
    if s == "none" do
      IO.puts "UA"
      GibberChat.RoomController.unauthorized(conn)
    else
      r
    end
  end

  def auth_admin(adm_token) do
    query = from u in GibberChat.User, where: u.access_token == ^adm_token and u.admin == true
    res = GibberChat.Repo.all(query)
    s = "none"
    IO.puts "is empty"
    IO.inspect Enum.empty?(res)
    unless Enum.empty?(res) do
      IO.puts "OK"
      %{status: "ok", res: res}
    else
      %{status: "none", res: res}
    end
  end
  def find_user(user_token) do
    query = from r in GibberChat.User, where: r.access_token == ^user_token
    GibberChat.Repo.one(query)
  end

  def find_user_with_tokens(id) do
    query = from r in GibberChat.User, where: r.id == ^id, preload: [room_users: :room], preload: [:tags]
    GibberChat.Repo.one(query)
  end

  def find_user_with_token_tokens(token) do
    query = from r in GibberChat.User, where: r.access_token == ^token, preload: [room_users: :room], preload: [:tags]
    GibberChat.Repo.one(query)
  end

  def find_user_id(id) do
    query = from r in GibberChat.User, where: r.id == ^id
    GibberChat.Repo.one(query)
  end
end
