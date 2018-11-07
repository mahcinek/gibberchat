defmodule GibberChat.Room do
  use GibberChat.Web, :model

  schema "rooms" do
    field :title, :string
    field :access_token, :string
    field :open, :boolean, default: false
    field :save_on, :boolean, default: false
    field :auth_on, :boolean, default: false
    field :options, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :access_token, :open, :save_on, :auth_on, :options])
    |> validate_required([:title, :access_token, :open, :save_on, :auth_on, :options])
    |> unique_constraint(:access_token)
  end
end