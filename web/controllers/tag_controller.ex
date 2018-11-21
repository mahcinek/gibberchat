defmodule GibberChat.TagController do
  use GibberChat.Web, :controller
  def auth_adm(conn,token) do
    GibberChat.User.auth_adm_helper(conn,token)
  end

  def index(conn, %{"auth_token" => auth_token}) do
    adm = auth_adm(conn,auth_token)
    tags = GibberChat.Tag.all_tags
    json(conn, tags_response(tags))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "label" => label
                     }) do
    adm = auth_adm(conn,auth_token)
    tag = GibberChat.Repo.insert(%GibberChat.Tag{label: label})
    tag = GibberChat.ApiController.check_insert(conn, tag)
    json(conn, tag_response(tag))
  end

  def create(conn, %{"auth_token" => auth_token,
                     "label" => label
                     }) do
    adm = auth_adm(conn,auth_token)
    tag = GibberChat.Repo.insert(%GibberChat.Tag{label: label})
    tag = GibberChat.ApiController.check_insert(conn, tag)
    json(conn, tag_response(tag))
  end

  def add_to_user(conn,%{"auth_token" => auth_token,
                     "user_id" => user_id,
                     "tag_id" => tag_id
                     }) do
    adm = auth_adm(conn,auth_token)
    user = find_user(conn, user_id)
    tag = find_tag(conn, tag_id)
    user_tag = GibberChat.Repo.insert(%GibberChat.RoomTag{room_id: user.id, tag_id: tag.id})
    u_tag = GibberChat.ApiController.check_insert(conn, user_tag)
    GibberChat.ApiController.created(conn)
  end

  def add_to_room(conn, %{"auth_token" => auth_token,
                     "room_id" => room_id,
                     "tag_id" => tag_id
                     }) do
    adm = auth_adm(conn,auth_token)
    room = find_room(conn,room_id)
    tag = find_tag(conn, tag_id)
    room_tag = GibberChat.Repo.insert(%GibberChat.RoomTag{room_id: room.id, tag_id: tag.id})
    r_tag = GibberChat.ApiController.check_insert(conn, room_tag)
    GibberChat.ApiController.created(conn)
  end

  def tag_response(tag) do
      %{id: tag.id,
        label: tag.label
      }
  end

  def delete(conn, %{"auth_token" => auth_token, "id" => id}) do
    adm = auth_adm(conn, auth_token)
    message = find_tag(conn, id)
    GibberChat.Repo.delete!(message)
    json(conn, %{status: "deleted"})
  end

  def find_tag(conn, id) do
    tag = GibberChat.Tag.find_tag_id(id)
    unless tag == nil do 
      tag
    else
      GibberChat.ApiController.not_found(conn)
    end
  end

  def tags_response(tags) do
    Enum.map(tags, fn elem -> tag_response(elem) end)
  end

  def find_room(conn, id) do
    room = GibberChat.Room.find_room_id(id)
    unless room == nil do 
      room
    else
      GibberChat.ApiController.not_found_message(conn, "room")
    end
  end
  def find_user(conn, id) do
    room = GibberChat.User.find_user_id(id)
    unless room == nil do 
      room
    else
      GibberChat.ApiController.not_found_message(conn, "user")
    end
  end

  def find_tag(conn, id) do
    tag = GibberChat.Tag.find_tag_id(id)
    unless tag == nil do 
      tag
    else
      GibberChat.ApiController.not_found_message(conn, "tag")
    end
  end
end