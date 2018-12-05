defmodule GibberChat.UserTagTest do
  use GibberChat.ModelCase

  alias GibberChat.UserTag

  @valid_attrs %{user_id: 1, tag_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserTag.changeset(%UserTag{}, @valid_attrs)
    assert changeset.valid?
  end

end
