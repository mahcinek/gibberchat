defmodule GibberChat.MessageController do
  use GibberChat.Web, :controller
  def auth_adm(conn,token) do
    GibberChat.User.auth_adm_helper(conn,token)
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

end