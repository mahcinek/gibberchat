defmodule GibberChat.UserController do
  use GibberChat.Web, :controller
  def auth_adm(conn,token) do
    GibberChat.User.auth_adm_helper(conn,token)
  end

  def create(conn, %{"auth_token" => auth_token,
                     "nick" => nick,
                     "options" => opts
                     }) do
    adm = auth_adm(conn,auth_token)
    user = GibberChat.Repo.insert(%GibberChat.User{nick: nick, options: opts})
    user = GibberChat.ApiController.check_insert(conn, user)
    json(conn, user_response(user))
  end

  def delete(conn, %{"auth_token" => auth_token, "id" => id}) do
    adm = auth_adm(conn, auth_token)
    message = find_user(conn, id)
    GibberChat.Repo.delete!(message)
    json(conn, %{status: "deleted"})
  end

  def find_user(conn, id) do
    room = GibberChat.User.find_user_id(id)
    unless room == nil do 
      room
    else
      GibberChat.ApiController.not_found(conn)
    end
  end

  def user_response(user) do
      %{id: user.id,
        nick: user.nick,
        options: user.options
      }
  end
end