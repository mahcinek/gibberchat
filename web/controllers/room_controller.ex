defmodule GibberChat.RoomController do
  use GibberChat.Web, :controller
  require IEx

  def index(conn, %{"auth_token" => auth_token}) do
    adm = auth_adm(conn,auth_token)
    a = GibberChat.Room.all_rooms()
    IO.inspect a
    json(conn, Enum.map(a, fn elem -> room_response(elem) end))
  end

  def index(conn, _params) do
    a = GibberChat.Room.open_rooms()
    IO.inspect a
    json(conn, Enum.map(a, fn elem -> room_public_response(elem) end))
  end

  def show(conn, %{"id" => id}) do
    
  end
  
  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts,
                     "access_token" => ac_token,
                     "title" => title,
                     "open" => open}) do
    adm = auth_adm(conn,auth_token)
    room = GibberChat.Repo.insert(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: elem(Ecto.Type.cast(:boolean,auth_on),1), access_token: ac_token, options: opts})
    room = GibberChat.ApiController.check_insert(conn, room)
    json(conn, room_response(room))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts,
                     "title" => title,
                     "open" => open}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = token_check(auth_on)
    room = GibberChat.Repo.insert(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token, options: opts, open: elem(Ecto.Type.cast(:boolean,open),1)})
    room = GibberChat.ApiController.check_insert(conn, room)
    json(conn, room_response(room))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts,
                     "title" => title,
                     "open" => open}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = token_check(auth_on)
    room = GibberChat.Repo.insert(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token, options: opts, open: elem(Ecto.Type.cast(:boolean,open),1)})
    room = GibberChat.ApiController.check_insert(conn, room)
    json(conn, room_response(room))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "title" => title,
                     "open" => open}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = token_check(auth_on)
    room = GibberChat.Repo.insert(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token, open: elem(Ecto.Type.cast(:boolean,open),1)})
    room = GibberChat.ApiController.check_insert(conn, room)
    json(conn, room_response(room))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "title" => title}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = token_check(auth_on)
    room = GibberChat.Repo.insert(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token, title: title})
    room = GibberChat.ApiController.check_insert(conn, room)
    json(conn, room_response(room))
  end
  
  def update(conn, %{"auth_token" => auth_token,
                     "id" => id,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts,
                     "access_token" => ac_token,
                     "title" => title,
                     "open" => open}) do
    adm = auth_adm(conn,auth_token)
    room = find_room(conn, id)
    changeset = GibberChat.Room.changeset(room, %{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: elem(Ecto.Type.cast(:boolean,auth_on),1), options: opts, access_token: ac_token, title: title, open: elem(Ecto.Type.cast(:boolean,open),1)})
    r = GibberChat.Repo.update(changeset)
    json(conn, room_response(elem(r,1)))
  end

  def update(conn, %{"auth_token" => auth_token,
                    "id" => id,
                    "save_on" => save_on,
                    "auth_on" => auth_on,
                    "options" => opts,
                    "title" => title,
                    "open" => open}) do
    adm = auth_adm(conn,auth_token)
    room = find_room(conn, id)
    changeset = GibberChat.Room.changeset(room, %{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: elem(Ecto.Type.cast(:boolean,auth_on),1), options: opts, title: title, open: elem(Ecto.Type.cast(:boolean,open),1)})
    r = GibberChat.Repo.update(changeset)
    json(conn, room_response(elem(r,1)))
  end
    
  def delete(conn, %{"auth_token" => auth_token, "id" => id}) do
    adm = auth_adm(conn, auth_token)
    room = find_room(conn, id)
    IO.inspect room
    IEx.Info.info(room)
    GibberChat.Repo.delete!(room)
    json(conn, %{status: "deleted"})
  end

  def gen_access_token() do
    lt = 60
    random_token = :crypto.strong_rand_bytes(lt) |> Base.encode64 |>binary_part(0,lt)
  end

  def auth_adm(conn,token) do
    GibberChat.User.auth_adm_helper(conn,token)
  end

  def room_response(room) do
    %{id: room.id,
        title: room.title,
        save_on: room.save_on,
        auth_on: room.auth_on,
        inserted_at: room.inserted_at,
        options: room.options,
        access_token: room.access_token,
        open: room.open,
        tags: tag_resp(room.tags)
      }
  end
  def room_public_response(room) do
    %{id: room.id,
        title: room.title,
        save_on: room.save_on,
        auth_on: room.auth_on,
        inserted_at: room.inserted_at,
        options: room.options,
        open: room.open,
        tags: tag_resp(room.tags)
      }
  end
  
  def tag_resp(tags) do
    Enum.map(tags, fn elem -> tag_response(elem) end)
  end

  def tag_response(tag) do
    %{
      id: tag.id,
      label: tag.label
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
      GibberChat.ApiController.not_found(conn)
    end
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
