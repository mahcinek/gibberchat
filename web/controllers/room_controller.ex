defmodule GibberChat.RoomController do
  use GibberChat.Web, :controller

  def index(conn, _params) do
    response = %{rooms: GibberChat.Room.open_rooms()}
    json(conn, response)
  end
  
  def create(conn, %{"auth_token" => auth_token}) do
    adm = auth_adm(conn,auth_token)
    response = %{status: "ok"}
    json(conn, response)
  end
  
  # def update(conn, %{"id" => id, "post" => post_params}) do
  
  # end
  
  # def delete(conn, %{"id" => id}) do
  
  # end

  def auth_adm(conn,token) do
    resp = GibberChat.User.auth_admin(token)
    IO.inspect resp
    %{res: r, status: s} = resp
    if s == "none" do
      IO.inspect 'not f'
      conn
      |> put_status(:not_found)
      |> json(%{status: "not found"})
    else
      r
    end
  end
end
