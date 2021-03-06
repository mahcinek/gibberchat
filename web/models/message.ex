defmodule GibberChat.Message do
  use GibberChat.Web, :model

  schema "messages" do
    field :body, :string
    field :options, :string
    belongs_to :room, GibberChat.Room, foreign_key: :room_id
    belongs_to :user, GibberChat.User, foreign_key: :user_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :options])
    |> validate_required([:body])
  end

  def save_message(body, opts, user_id, room_id) do
    m = GibberChat.Repo.insert(%GibberChat.Message{body: body, options: opts, user_id: user_id, room_id: room_id})
    IO.puts "Inserted #{elem(m,1).id}"
  end

  def find_message_id(id) do
    query = from r in GibberChat.Message, where: r.id == ^id
    GibberChat.Repo.one(query)
  end
end
