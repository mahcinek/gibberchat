defmodule GibberChat.RoomController do
  use GibberChat.Web, :controller

  def index(conn, _params) do
    response = %{rooms: GibberChat.Room.open_rooms()}
    json(conn, response)
  end
  
  def create(conn, %{"auth_token" => auth_token,
                     "tags" => tags,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts,
                     "access_token" => ac_token,
                     "title" => title}) do
    adm = auth_adm(conn,auth_token)
    room = GibberChat.Repo.insert!(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: elem(Ecto.Type.cast(:boolean,auth_on),1), access_token: ac_token, options: opts})
    handle_tags(room, tags)
    json(conn, room_response(room))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "tags" => tags,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts,
                     "title" => title}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = token_check(auth_on)
    room = GibberChat.Repo.insert!(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token, options: opts})
    handle_tags(room, tags)
    json(conn, room_response(room))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts,
                     "title" => title}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = token_check(auth_on)
    room = GibberChat.Repo.insert!(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token, options: opts})
    json(conn, room_response(room))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "tags" => tags,
                     "title" => title}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = token_check(auth_on)
    room = GibberChat.Repo.insert!(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token})
    handle_tags(room, tags)
    json(conn, room_response(room))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "title" => title}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = token_check(auth_on)
    room = GibberChat.Repo.insert!(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token, title: title})
    json(conn, room_response(room))
  end
  
  def update(conn, %{"auth_token" => auth_token,
                     "id" => id,
                     "tags" => tags,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts,
                     "access_token" => ac_token,
                     "title" => title}) do
    adm = auth_adm(conn,auth_token)
    room = find_room(conn, id)
    handle_tags(room, tags)
    changeset = GibberChat.Room.changeset(room, %{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: elem(Ecto.Type.cast(:boolean,auth_on),1), options: opts, access_token: ac_token, title: title})
    GibberChat.Repo.update(changeset)
  end

  def update(conn, %{"auth_token" => auth_token,
                    "id" => id,
                    "tags" => tags,
                    "save_on" => save_on,
                    "auth_on" => auth_on,
                    "options" => opts,
                    "title" => title}) do
    adm = auth_adm(conn,auth_token)
    room = find_room(conn, id)
    handle_tags(room, tags)
    changeset = GibberChat.Room.changeset(room, %{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: elem(Ecto.Type.cast(:boolean,auth_on),1), options: opts, title: title})
    GibberChat.Repo.update(changeset)
  end
    
  def delete(conn, %{"auth_token" => auth_token, "id" => id}) do
    adm = auth_adm(conn, auth_token)
    room = find_room(conn, id)
    IO.inspect room
    IEx.Info.info(room)
    GibberChat.Repo.delete!(room)
    json(conn, %{status: "deleted"})
  end

  def handle_tags(room, tag_list) do

  end

  def gen_access_token() do
    lt = 60
    random_token = :crypto.strong_rand_bytes(lt) |> Base.encode64 |>binary_part(0,lt)
  end

  def auth_adm(conn,token) do
    resp = GibberChat.User.auth_admin(token)
    IO.inspect resp
    %{res: r, status: s} = resp
    if s == "none" do
      IO.puts "UA"
      unauthorized(conn)
    else
      r
    end
  end

  def room_response(room) do
    %{id: room.id,
        title: room.title,
        save_on: room.save_on,
        auth_on: room.auth_on,
        inserted_at: room.inserted_at,
        options: room.options,
        access_token: room.access_token
      }
  end
  
  def token_check(auth_on) do
    if auth_on do
      IO.puts "Gen token"
      gen_access_token()
    else
      nil
    end
  end

  def find_room(conn, id) do
    room = GibberChat.Room.find_room_id(id)
    unless room == nil do 
      room
    else
      not_found(conn)
    end
  end

  def not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{status: "not found"})
  end
  def unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{status: "Not Authorized"})
  end
  def forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{status: "Forbidden"})
  end
end
