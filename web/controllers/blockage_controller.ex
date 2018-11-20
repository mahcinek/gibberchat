defmodule GibberChat.BlockageController do
  use GibberChat.Web, :controller
  def auth_adm(conn,token) do
    GibberChat.User.auth_adm_helper(conn,token)
  end

  def create(conn, %{"auth_token" => auth_token,
                     "room_id" => room,
                     "user_id" => user
                     }) do
    adm = auth_adm(conn,auth_token)
    room = GibberChat.Repo.insert(%GibberChat.Blockage{room_id: room, user_id: user})
    room = GibberChat.ApiController.check_insert(conn, room)
    json(conn, blockage_response(room))
  end

  def delete(conn, %{"auth_token" => auth_token, "id" => id}) do
    adm = auth_adm(conn, auth_token)
    message = find_blockage(conn, id)
    GibberChat.Repo.delete!(message)
    json(conn, %{status: "deleted"})
  end

  def blockage_response(message) do
      %{id: message.id,
        body: message.body,
        options: message.options
      }
  end

    def find_blockage(conn, id) do
    room = GibberChat.Blockage.find_blockage_id(id)
    unless room == nil do 
      room
    else
      GibberChat.ApiController.not_found(conn)
    end
  end
end