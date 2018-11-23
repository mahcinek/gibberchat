defmodule GibberChat.RoomUser do
  use GibberChat.Web, :model

  schema "room_users" do
    field :auth_token, :string
    belongs_to :room, GibberChat.Room, foreign_key: :room_id
    belongs_to :user, GibberChat.User, foreign_key: :user_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:auth_token])
    |> validate_required([:auth_token])
  end

  def auth_user(room_id, user_token) do
    query = from ru in GibberChat.RoomUser, where: ru.room_id == ^room_id and ru.auth_token == ^user_token
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
end
