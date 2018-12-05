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
    IO.inspect token
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

  def find_user_all_token(conn, token) do
    user = GibberChat.User.find_user_with_token_tokens(token)
    unless user == nil do
      user
    else
      GibberChat.ApiController.not_found(conn)
    end
  end

  def find_users_all_tag(conn, tag) do
    tag = GibberChat.Tag.find_tag_label_users(tag)
    unless tag == nil do
      tag
    else
      GibberChat.ApiController.not_found_message(conn, "tag")
    end
  end

  def show(conn,%{"auth_token" => auth_token,
                     "id" => us_id
                     })do
    adm = auth_adm(conn, auth_token)
    user = find_user_all(conn,us_id)
    IO.inspect user
    json(conn, user_response_with_tokens(user))
  end

  def show(conn,%{"auth_token" => auth_token,
                     "access_token" => token
                     })do
    adm = auth_adm(conn, auth_token)
    user = find_user_all_token(conn,token)
    IO.inspect user
    json(conn, user_response_with_tokens(user))
  end

  def search(conn,%{"auth_token" => auth_token,
                     "tag" => tag
                     })do
    adm = auth_adm(conn, auth_token)
    tag = find_users_all_tag(conn,tag)
    users = tag.users
    IO.inspect users
    json(conn, %{users: generate_users_map_private(users)})
  end

  def user_response(user) do
      %{id: user.id,
        nick: user.nick,
        options: user.options,
        access_token: user.access_token
      }
  end
  def user_response_with_tokens(user) do
      %{id: user.id,
        nick: user.nick,
        options: user.options,
        access_token: user.access_token,
        tokens: generate_tokens_map(user.room_users),
        tags: generate_tags_map(user.tags)
      }
  end

  def generate_tokens_map(tokens) do
    Enum.map(tokens, fn elem -> token_resp(elem) end)
  end

  def generate_users_map_private(users) do
    Enum.map(users, fn elem -> user_response(elem) end)
  end

  def token_resp(room_user)do
    %{auth_token: room_user.auth_token,
      room_id: room_user.room.id,
      room_access_token: room_user.room.access_token,
      room_open: room_user.room.open,
      room_title: room_user.room.title
    }
  end

  def tag_resp(tag)do
    %{
      id: tag.id,
      label: tag.label
      }
  end

  def generate_tags_map(tags) do
    Enum.map(tags, fn elem -> tag_resp(elem) end)
  end

  def gen_access_token(lt) do
    random_token = :crypto.strong_rand_bytes(lt) |> Base.encode64 |>binary_part(0,lt)
  end
end
