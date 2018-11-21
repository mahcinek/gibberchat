defmodule GibberChat.ChatroomChannel do
  use GibberChat.Web, :channel

  alias GibberChat.Presence

  def join("chatroom:" <> room_access_token, _params, socket) do
    send self(), :after_join
    find_room(room_access_token, socket)
  end
  
  def join(_other, _params, socket) do
    {:error, "Room does not exist."}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })
    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new", %{
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end

  def find_room(token, socket) do
    r = GibberChat.Room.find_room(token)
    if r == nil do
      {:error, "Room does not exist."}
    else
      {:ok, socket}
    end
  end
end