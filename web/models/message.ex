defmodule GibberChat.Message do
  use GibberChat.Web, :model

  schema "messages" do
    field :body, :string
    field :options, :string
    belongs_to :room, GibberChat.Room, foreign_key: :room_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :options])
    |> validate_required([:body, :options])
  end

  def find_message_id(id) do
    query = from r in GibberChat.Message, where: r.id == ^id
    GibberChat.Repo.one(query)
  end
end
