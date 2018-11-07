defmodule GibberChat.UserTagTest do
  use GibberChat.ModelCase

  alias GibberChat.UserTag

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserTag.changeset(%UserTag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserTag.changeset(%UserTag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
