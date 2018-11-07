defmodule GibberChat.UserTest do
  use GibberChat.ModelCase

  alias GibberChat.User

  @valid_attrs %{nick: "some nick", options: "some options"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
