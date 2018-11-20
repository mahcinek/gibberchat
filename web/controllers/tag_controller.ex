defmodule GibberChat.TagController do
  use GibberChat.Web, :controller
  def auth_adm(conn,token) do
    GibberChat.User.auth_adm_helper(conn,token)
  end

  def create(conn, %{"auth_token" => auth_token,
                     "label" => label
                     }) do
    adm = auth_adm(conn,auth_token)
    tag = GibberChat.Repo.insert!(%GibberChat.Tag{label: label})
    json(conn, tag_response(tag))
  end

  def add_to_user do
  end

  def add_to_room(conn, %{"auth_token" => auth_token,
                     "room_id" => room,
                     "tag_id" => tag
                     }) do

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
    room = GibberChat.Tag.find_tag_id(id)
    unless room == nil do 
      room
    else
      GibberChat.ApiController.not_found(conn)
    end
  end
end