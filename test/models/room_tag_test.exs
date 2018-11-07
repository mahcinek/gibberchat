defmodule GibberChat.RoomTagTest do
  use GibberChat.ModelCase

  alias GibberChat.RoomTag

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RoomTag.changeset(%RoomTag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RoomTag.changeset(%RoomTag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
