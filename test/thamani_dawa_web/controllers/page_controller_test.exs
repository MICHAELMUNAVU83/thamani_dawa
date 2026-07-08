defmodule ThamaniDawaWeb.PageControllerTest do
  use ThamaniDawaWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "The pharmacy OS"
  end

  test "GET /privacy", %{conn: conn} do
    conn = get(conn, ~p"/privacy")
    assert html_response(conn, 200) =~ "Privacy"
  end

  test "GET /terms", %{conn: conn} do
    conn = get(conn, ~p"/terms")
    assert html_response(conn, 200) =~ "Terms"
  end

  test "GET /contact", %{conn: conn} do
    conn = get(conn, ~p"/contact")
    assert html_response(conn, 200) =~ "Contact"
    assert %Phoenix.HTML.Form{} = conn.assigns.form
  end
end
