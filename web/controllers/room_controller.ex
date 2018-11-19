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
                     "access_token" => ac_token}) do
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on,
                     "options" => opts}) do
    adm = auth_adm(conn,auth_token)
    IO.puts "OPTIONS"
    room = GibberChat.Repo.insert!(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1),
                                                    auth_on: elem(Ecto.Type.cast(:boolean,auth_on),1),
                                                    options: opts})
    IO.inspect room
    response = %{id: room.id,
                 title: room.title,
                 save_on: room.save_on,
                 auth_on: room.auth_on,
                 inserted_at: room.inserted_at,
                 options: room.options,
                 access_token: room.access_token
                }
    json(conn, response)
  end

  def create(conn, %{"auth_token" => auth_token,
                     "save_on" => save_on,
                     "auth_on" => auth_on}) do
    adm = auth_adm(conn,auth_token)
    auth_on = elem(Ecto.Type.cast(:boolean,auth_on),1)
    token = nil
    IO.puts "auth_on"
    IO.inspect auth_on
    token = if auth_on do
      IO.puts "Gen token"
      gen_access_token()
    else
      nil
    end
    IO.puts "TOKEN"
    IO.puts token
    room = GibberChat.Repo.insert!(%GibberChat.Room{save_on: elem(Ecto.Type.cast(:boolean,save_on),1), auth_on: auth_on, access_token: token})
    response = %{id: room.id,
                 title: room.title,
                 save_on: room.save_on,
                 auth_on: room.auth_on,
                 inserted_at: room.inserted_at,
                 options: room.options,
                 access_token: room.access_token
                }
    json(conn, response)
  end
  
  
  
  # def update(conn, %{"id" => id, "post" => post_params}) do
  
  # end
  
  # def delete(conn, %{"id" => id}) do
  
  # end

  def handle_tags(tag_list) do

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
