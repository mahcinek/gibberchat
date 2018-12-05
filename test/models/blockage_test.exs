defmodule GibberChat.BlockageTest do
  use GibberChat.ModelCase

  alias GibberChat.Blockage

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Blockage.changeset(%Blockage{}, @valid_attrs)
    assert changeset.valid?
  end

end
