defmodule GibberChat.PageControllerTest do
  use GibberChat.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Type and press enter..."
  end
end
