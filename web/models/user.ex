defmodule GibberChat.User do
  use GibberChat.Web, :model

  schema "users" do
    field :nick, :string
    field :options, :string
    field :admin, :boolean, default: false
    field :access_token, :string
    has_many :user_tags, GibberChat.UserTag
    has_many :tags, through: [:user_tags, :tag]
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nick, :options, :admin])
    |> validate_required([:nick, :options, :admin])
    |> unique_constraint(:nick)
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
  def auth_user(user_token) do
  end

  def find_user_id(id) do
    query = from r in GibberChat.User, where: r.id == ^id
    GibberChat.Repo.one(query)
  end
end
