defmodule GibberChat.Router do
  use GibberChat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug, origin: "*"
  end

  scope "/", GibberChat do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", GibberChat do
    pipe_through :api
    post "/user", UserController, :create
    delete "/user", UserController, :delete
    get "/user", UserController, :show
    get "/search_user", UserController, :search
    post "/blockage", BlockageController, :create
    delete "/blockage", BlockageController, :delete
    get "/tags", TagController, :index
    post "/tag", TagController, :create
    put "/tag", TagController, :update
    post "/add_to_user", TagController, :add_to_user
    post "/add_to_room", TagController, :add_to_room
    delete "/tag", TagController, :delete
    get "/messages", MessageController, :index
    get "/room_messages", MessageController, :room_messages
    put "/message", MessageController, :update
    delete "/message", MessageController, :delete
    get "/rooms", RoomController, :index
    post "/join_room", RoomController, :join_room
    post "/leave", RoomController, :join_room
    get "/search_room", RoomController, :search
    post "/room", RoomController, :create
    put "/room", RoomController, :update
    delete "/room", RoomController, :delete
  end
end
