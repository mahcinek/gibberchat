defmodule GibberChat.User do
  use GibberChat.Web, :model

  schema "users" do
    field :nick, :string
    field :options, :string
    field :admin, :boolean, default: false
    field :access_token, :string

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
end
