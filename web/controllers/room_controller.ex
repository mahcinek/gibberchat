defmodule GibberChat.RoomController do
  use GibberChat.Web, :controller
  require IEx

  def index(conn, %{"auth_token" => auth_token}) do
    adm = auth_adm(conn,auth_token)
    a = GibberChat.Room.all_rooms()
    json(conn, %{rooms: Enum.map(a, fn elem -> room_response(elem) end)})
  end

  def index(conn, _params) do
    a = GibberChat.Room.open_rooms()
    json(conn, %{rooms: Enum.map(a, fn elem -> room_public_response(elem) end)})
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
    token = token_check(true)
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
    token = token_check(true)
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
    token = token_check(true)
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
    token = token_check(true)
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

  def search(conn,%{"auth_token" => auth_token,
                     "tag" => tag
                     })do
    adm = auth_adm(conn, auth_token)
    tag = find_rooms_all_tag(conn,tag)
    rooms = tag.rooms
    IO.inspect rooms
    json(conn, %{rooms: Enum.map(rooms, fn elem -> room_response(elem) end)})
  end

  def join_room(conn, %{"admin_auth_token" => auth_token, "room_access_token" => acc_token, "user_id" => us_id}) do
    adm = auth_adm(conn, auth_token)
    room = find_room_token(conn, acc_token)
    us_id = elem(Ecto.Type.cast(:integer,us_id),1)
    r_u = if room.auth_on do
      r_u = GibberChat.Repo.insert(%GibberChat.RoomUser{user_id: us_id, room_id: room.id, auth_token: gen_access_token()})
       GibberChat.ApiController.check_insert(conn, r_u)
    else
      r_u = GibberChat.Repo.insert(%GibberChat.RoomUser{user_id: us_id, room_id: room.id, auth_token: nil})
      r_u = GibberChat.ApiController.check_insert(conn, r_u)
    end
    conn
    |> GibberChat.ApiController.add_created
    |> json(room_user(r_u))
  end

  # def join_room(conn, %{"user_auth_token" => auth_token, "room_access_token" => acc_token}) do
  #   user = find_user(auth_token)
  #   room = find_room_token(conn, acc_token)
  #   room_user = if room.auth_on do
  #     room_user = GibberChat.Repo.insert(%GibberChat.RoomUser{user_id: us_id, room_id: room.id, access_token: gen_access_token()})
  #      GibberChat.ApiController.check_insert(conn, room_user)
  #   else
  #     room_user = GibberChat.Repo.insert(%GibberChat.RoomUser{user_id: us_id, room_id: room.id})
  #     GibberChat.ApiController.check_insert(conn, room_user)
  #   end
  #   GibberChat.ApiController.created(conn)
  # end

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
  def room_user(room_user) do
    %{
      id: room_user.id,
      access_token: room_user.auth_token
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

  def find_room_token(conn, token) do
    room = GibberChat.Room.find_room(token)
    unless room == nil do
      room
    else
      GibberChat.ApiController.not_found(conn)
    end
  end

  def find_rooms_all_tag(conn, tag) do
    tag = GibberChat.Tag.find_tag_label_rooms(tag)
    unless tag == nil do
      tag
    else
      GibberChat.ApiController.not_found_message(conn, "tag")
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
