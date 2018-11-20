  defmodule GibberChat.ApiController do
  use GibberChat.Web, :controller
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