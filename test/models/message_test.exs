defmodule GibberChat.MessageTest do
  use GibberChat.ModelCase

  alias GibberChat.Message

  @valid_attrs %{body: "some body", options: "some options"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
