defmodule GibberChat.RoomUserTest do
  use GibberChat.ModelCase

  alias GibberChat.RoomUser

  @valid_attrs %{auth_token: "some auth_token"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RoomUser.changeset(%RoomUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RoomUser.changeset(%RoomUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
