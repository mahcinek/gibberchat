defmodule GibberChat.UserTag do
  use GibberChat.Web, :model

  schema "user_tags" do
    belongs_to :user, GibberChat.User, foreign_key: :user_id
    belongs_to :tag, GibberChat.Tag, foreign_key: :tag_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
