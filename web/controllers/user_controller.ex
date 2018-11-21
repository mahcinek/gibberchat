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
    token = gen_access_token(90)
    a = GibberChat.Repo.insert(GibberChat.User.changeset(%GibberChat.User{},%{nick: nick, options: opts, access_token: token}))
    user = GibberChat.ApiController.check_insert(conn, a)
    json(conn, user_response(user))
  end

  def delete(conn, %{"auth_token" => auth_token, "id" => id}) do
    adm = auth_adm(conn, auth_token)
    user = find_user(conn, id)
    GibberChat.Repo.delete!(user)
    json(conn, %{status: "deleted"})
  end

  def find_user(conn, id) do
    user = GibberChat.User.find_user_id(id)
    unless user == nil do 
      user
    else
      GibberChat.ApiController.not_found(conn)
    end
  end
  def find_user_all(conn, id) do
    user = GibberChat.User.find_user_with_tokens(id)
    unless user == nil do 
      user
    else
      GibberChat.ApiController.not_found(conn)
    end
  end

  def show(conn,%{"auth_token" => auth_token,
                     "user_id" => us_id
                     })do
    adm = auth_adm(conn, auth_token)
    user = find_user_all(conn,us_id)
    IO.inspect user
    json(conn, %{st: "ok"})
  end

  def user_response(user) do
      %{id: user.id,
        nick: user.nick,
        options: user.options
      }
  end
  def user_response_with_tokens(user) do
      %{id: user.id,
        nick: user.nick,
        options: user.options,
        tokens: generate_tokens_map(user.room_users),
        tags: generate_tags_map(user.room_users)
      }
  end

  def generate_tokens_map(tokens) do
    %{t1: "aaa"}
  end

  def generate_tags_map(tags) do
    %{t2: "aaa"}
  end

  def gen_access_token(lt) do
    random_token = :crypto.strong_rand_bytes(lt) |> Base.encode64 |>binary_part(0,lt)
  end
end