defmodule GibberChat.RoomTest do
  use GibberChat.ModelCase

  alias GibberChat.Room

  @valid_attrs %{access_token: "some access_token", auth_on: true, open: true, options: "some options", save_on: true, title: "some title"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Room.changeset(%Room{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Room.changeset(%Room{}, @invalid_attrs)
    refute changeset.valid?
  end
end
