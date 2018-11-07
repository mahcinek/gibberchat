# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GibberChat.Repo.insert!(%GibberChat.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.

ln = 10
lt = 50
random_nick = :crypto.strong_rand_bytes(ln) |> Base.encode64 |>binary_part(0,ln)
random_token = :crypto.strong_rand_bytes(lt) |> Base.encode64 |>binary_part(0,lt)
GibberChat.Repo.insert!(%GibberChat.User{nick: random_nick, admin: true, access_token: random_token})
