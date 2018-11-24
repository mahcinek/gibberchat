defmodule GibberChat.ChatSocket do
  use Phoenix.Socket

  ## Channels
  channel "chatroom:*", GibberChat.ChatroomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"access_token" => token}, socket) do
    IO.puts "connecting token #{token}"
    check_token(socket,token)
  end

  def connect(_params, _socket) do
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     GibberChat.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.

  def id(socket), do: "chat_socket:#{socket.assigns.user_token}"

  def check_token(socket,token) do
    us = GibberChat.User.find_user(token)

    if us == nil do
      :error
    else
      socket = assign(socket,:nick, us.nick)
      IO.puts "Asigning #{us.nick}"
      socket = assign(socket,:us_id, us.id)
      {:ok, assign(socket, :user_token, token)}
    end
  end
end
