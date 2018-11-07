defmodule GibberChat.User do
  use GibberChat.Web, :model

  schema "users" do
    field :nick, :string
    field :options, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nick, :options])
    |> validate_required([:nick, :options])
    |> unique_constraint(:nick)
  end
end
