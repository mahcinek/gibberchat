defmodule GibberChat.MessageController do
  use GibberChat.Web, :controller
  def auth_adm(conn,token) do
    GibberChat.User.auth_adm_helper(conn,token)
  end
  def auth_user(conn,room_id,token) do
    {status, res} = GibberChat.RoomUser.auth_user(room_id,token)
    if status == "ok"
      res
    else
      GibberChat.ApiController.unauthorized(conn)
    end
  end

  def room_messages(conn, %{"room_token" => r_token,
                            "user_token" => u_token})do
    user = find_user(conn, u_token)
    room = find_room_with_messages_ordered(conn, r_token)
    unless room.open do
      GibberChat.ApiController.unauthorized(conn)
    end
    json(conn, messages_response(room.messages))
  end

  def room_messages(conn, %{"room_token" => r_token,
                            "user_token" => u_token,
                            "auth_token" => u_auth_token})do
    user = find_user(conn, u_token)
    room = find_room_with_messages_ordered(conn, r_token)
    auth_user(conn, room.id, u_auth_token)
    json(conn, messages_response(room.messages))
  end
  
  def update(conn, %{"auth_token" => auth_token,
                     "body" => body,
                     "options" => opts,
                     "id" => id
                     }) do
    adm = auth_adm(conn,auth_token)
    message = find_message(conn, id)
    changeset = GibberChat.Message.changeset(message, %{body: body, options: opts})
    r = GibberChat.Repo.update(changeset)
    json(conn, message_response(elem(r,1)))
  end

  def delete(conn, %{"auth_token" => auth_token, "id" => id}) do
    adm = auth_adm(conn, auth_token)
    message = find_message(conn, id)
    GibberChat.Repo.delete!(message)
    json(conn, %{status: "deleted"})
  end

  def message_response(message) do
      %{id: message.id,
        body: message.body,
        options: message.options
      }
  end

  def find_message(conn, id) do
    room = GibberChat.Message.find_message_id(id)
    unless room == nil do 
      room
    else
      GibberChat.ApiController.not_found(conn)
    end
  end
  def find_messages_ordered(conn, room_id) do
    room = GibberChat.Message.find_message_id(id)
    unless room == nil do 
      room
    else
      GibberChat.ApiController.not_found(conn)
    end
  end

  def find_room(conn, token) do
    room = GibberChat.Room.find_room(token)
    unless room == nil do 
      room
    else
      GibberChat.ApiController.not_found(conn)
    end
  end



end