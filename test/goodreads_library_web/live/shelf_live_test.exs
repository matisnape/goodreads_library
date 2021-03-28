defmodule GoodreadsLibraryWeb.ShelfLiveTest do
  use GoodreadsLibraryWeb.ConnCase

  import Phoenix.LiveViewTest

  alias GoodreadsLibrary.Books

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(:shelf) do
    {:ok, shelf} = Books.create_shelf(@create_attrs)
    shelf
  end

  defp create_shelf(_) do
    shelf = fixture(:shelf)
    %{shelf: shelf}
  end

  describe "Index" do
    setup [:create_shelf]

    test "lists all shelves", %{conn: conn, shelf: shelf} do
      {:ok, _index_live, html} = live(conn, Routes.shelf_index_path(conn, :index))

      assert html =~ "Listing Shelves"
      assert html =~ shelf.name
    end

    test "saves new shelf", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.shelf_index_path(conn, :index))

      assert index_live |> element("a", "New Shelf") |> render_click() =~
               "New Shelf"

      assert_patch(index_live, Routes.shelf_index_path(conn, :new))

      assert index_live
             |> form("#shelf-form", shelf: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#shelf-form", shelf: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shelf_index_path(conn, :index))

      assert html =~ "Shelf created successfully"
      assert html =~ "some name"
    end

    test "updates shelf in listing", %{conn: conn, shelf: shelf} do
      {:ok, index_live, _html} = live(conn, Routes.shelf_index_path(conn, :index))

      assert index_live |> element("#shelf-#{shelf.id} a", "Edit") |> render_click() =~
               "Edit Shelf"

      assert_patch(index_live, Routes.shelf_index_path(conn, :edit, shelf))

      assert index_live
             |> form("#shelf-form", shelf: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#shelf-form", shelf: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shelf_index_path(conn, :index))

      assert html =~ "Shelf updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes shelf in listing", %{conn: conn, shelf: shelf} do
      {:ok, index_live, _html} = live(conn, Routes.shelf_index_path(conn, :index))

      assert index_live |> element("#shelf-#{shelf.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#shelf-#{shelf.id}")
    end
  end

  describe "Show" do
    setup [:create_shelf]

    test "displays shelf", %{conn: conn, shelf: shelf} do
      {:ok, _show_live, html} = live(conn, Routes.shelf_show_path(conn, :show, shelf))

      assert html =~ "Show Shelf"
      assert html =~ shelf.name
    end

    test "updates shelf within modal", %{conn: conn, shelf: shelf} do
      {:ok, show_live, _html} = live(conn, Routes.shelf_show_path(conn, :show, shelf))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Shelf"

      assert_patch(show_live, Routes.shelf_show_path(conn, :edit, shelf))

      assert show_live
             |> form("#shelf-form", shelf: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#shelf-form", shelf: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shelf_show_path(conn, :show, shelf))

      assert html =~ "Shelf updated successfully"
      assert html =~ "some updated name"
    end
  end
end
