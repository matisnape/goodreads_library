defmodule GoodreadsLibrary.BooksTest do
  use GoodreadsLibrary.DataCase

  alias GoodreadsLibrary.Books

  describe "shelves" do
    alias GoodreadsLibrary.Shelf

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def shelf_fixture(attrs \\ %{}) do
      {:ok, shelf} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Books.create_shelf()

      shelf
    end

    test "list_shelves/0 returns all shelves" do
      shelf = shelf_fixture()
      assert Books.list_shelves() == [shelf]
    end

    test "get_shelf!/1 returns the shelf with given id" do
      shelf = shelf_fixture()
      assert Books.get_shelf!(shelf.id) == shelf
    end

    test "create_shelf/1 with valid data creates a shelf" do
      assert {:ok, %Shelf{} = shelf} = Books.create_shelf(@valid_attrs)
      assert shelf.name == "some name"
    end

    test "create_shelf/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_shelf(@invalid_attrs)
    end

    test "update_shelf/2 with valid data updates the shelf" do
      shelf = shelf_fixture()
      assert {:ok, %Shelf{} = shelf} = Books.update_shelf(shelf, @update_attrs)
      assert shelf.name == "some updated name"
    end

    test "update_shelf/2 with invalid data returns error changeset" do
      shelf = shelf_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_shelf(shelf, @invalid_attrs)
      assert shelf == Books.get_shelf!(shelf.id)
    end

    test "delete_shelf/1 deletes the shelf" do
      shelf = shelf_fixture()
      assert {:ok, %Shelf{}} = Books.delete_shelf(shelf)
      assert_raise Ecto.NoResultsError, fn -> Books.get_shelf!(shelf.id) end
    end

    test "change_shelf/1 returns a shelf changeset" do
      shelf = shelf_fixture()
      assert %Ecto.Changeset{} = Books.change_shelf(shelf)
    end
  end
end
