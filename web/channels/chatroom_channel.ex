defmodule GibberChat.ChatroomChannel do
  use GibberChat.Web, :channel

  alias GibberChat.Presence

  def join("chatroom:" <> room_access_token, _params, socket) do
    # send self(), :after_join
    r = GibberChat.Room.find_room(room_access_token)
    check_room(r, socket)
  end

  def join(_other, _params, socket) do
    {:error, "Room does not exist."}
  end

  def track_id(socket, room_id) do
    dd = Presence.list(socket)
    IO.inspect dd
    if dd['room_id'] == nil do
      Presence.track(socket, "room_id", %{id: room_id})
    end
  end

  # def handle_info(:after_join, socket) do
  #   push socket, "presence_state", Presence.list(socket)
  #   Presence.track(socket, socket.assigns.user_token, %{
  #     online_at: :os.system_time(:milli_seconds)
  #   })
  #   {:noreply, socket}
  # end

  def handle_info(:after_join, socket, message) do
    {:noreply, socket}
  end
  def handle_info(_params, a) do
    {:noreply, a}
  end
  def handle_info(a, :ok) do
    {:noreply, a}
  end

  def handle_in("message:new", %{"body" => body, "options" => opts}, socket) do
    IO.inspect Presence.list(socket)
    broadcast! socket, "message:new", %{
      nick: socket.assigns.nick,
      body: body,
      options: opts,
      timestamp: :os.system_time(:milli_seconds)
    }
    GibberChat.ApiController.call_asynch_pls(fn ->
      mes(body, opts, socket.assigns.us_id, socket)
    end)
    {:noreply, socket}
  end

  def mes(body, opts, us_id, socket) do
    %{"room_id" => a} = Presence.list(socket)
    IO.puts "ssda"
    IO.inspect(a)
    r_id = elem(Map.fetch(List.first(elem(Map.fetch(a, :metas),1)), :id),1)
    GibberChat.Message.save_message(body, opts, socket.assigns.us_id,r_id)
  end

  def check_room(r, socket) do
    if r == nil do
      {:error, "Room does not exist."}
    else
      track_id(socket,r.id)
      {:ok, socket}
    end
  end
end
