defmodule GibberChat.Tag do
  use GibberChat.Web, :model

  schema "tags" do
    field :label, :string

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
