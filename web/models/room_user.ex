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
end
