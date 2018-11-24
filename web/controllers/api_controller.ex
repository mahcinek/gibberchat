  defmodule GibberChat.ApiController do
  use GibberChat.Web, :controller
  def not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{status: "not found"})
  end

  def call_asynch_pls(func) do
    Task.Supervisor.async_nolink(GibberChat.TaskSupervisor,func)
  end
  def check_insert(conn, insert) do
    {a,b} = insert
    if a == :ok do
      b
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{status: "unprocessable_entity"})
    end
  end
  def not_found_message(conn, message) do
    conn
    |> put_status(:not_found)
    |> json(%{status: message <> " " <> "not found"})
  end
  def unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{status: "Not Authorized"})
  end
  def created(conn) do
    conn
    |> put_status(:created)
    |> json(%{status: "Created"})
  end
  def add_created(conn) do
    conn
    |> put_status(:created)
  end
  def forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{status: "Forbidden"})
  end
end
