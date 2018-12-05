defmodule GibberChat.RoomControllerTest do
  use GibberChat.ConnCase

  alias GibberChat.Room

  test ".index displays public rooms", %{conn: conn} do
    rooms = [%GibberChat.Room{title: "t1", open: true, save_on: true, auth_on: false, options: ""},
             %GibberChat.Room{title: "t2", open: true, save_on: true, auth_on: false, options: ""}]
    rooms = Enum.map(rooms,fn elem -> GibberChat.Repo.insert!(elem) end)
    conn = get conn, "/api/rooms"
    [room1, room2] = rooms
    response =
    conn
    |> json_response(200)
    expected = %{
      "rooms" => [
        %{ "id" => room1.id, "inserted_at" => Ecto.DateTime.to_iso8601(elem(Ecto.DateTime.cast(room1.inserted_at),1)),"title" => room1.title, "tags" => [], "save_on" => true, "open" => true, "auth_on" => false, "options" => "" },
        %{ "id" => room2.id, "inserted_at" => Ecto.DateTime.to_iso8601(elem(Ecto.DateTime.cast(room2.inserted_at),1)),"title" => room2.title, "tags" => [], "save_on" => true, "open" => true, "auth_on" => false, "options" => "" }
      ]
    }
    assert response == expected
  end
end
