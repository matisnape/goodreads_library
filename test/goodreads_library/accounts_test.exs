defmodule GoodreadsLibrary.AccountsTest do
  use GoodreadsLibrary.DataCase

  alias GoodreadsLibrary.Accounts

  describe "books" do
    alias GoodreadsLibrary.Book

    @valid_attrs %{
      author: "some author",
      authorlf: "some authorlf",
      average_rating: 120.5,
      book_id: 42,
      bookshelves: [],
      date_added: ~D[2010-04-17],
      date_read: ~D[2010-04-17],
      pages_count: 42,
      publisher: "some publisher",
      title: "some title"
    }
    @update_attrs %{
      author: "some updated author",
      authorlf: "some updated authorlf",
      average_rating: 456.7,
      book_id: 43,
      bookshelves: [],
      date_added: ~D[2011-05-18],
      date_read: ~D[2011-05-18],
      pages_count: 43,
      publisher: "some updated publisher",
      title: "some updated title"
    }
    @invalid_attrs %{
      author: nil,
      authorlf: nil,
      average_rating: nil,
      book_id: nil,
      bookshelves: nil,
      date_added: nil,
      date_read: nil,
      pages_count: nil,
      publisher: nil,
      title: nil
    }

    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Accounts.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Accounts.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      assert {:ok, %Book{} = book} = Accounts.create_book(@valid_attrs)
      assert book.author == "some author"
      assert book.authorlf == "some authorlf"
      assert book.average_rating == 120.5
      assert book.book_id == 42
      assert book.bookshelves == []
      assert book.date_added == ~D[2010-04-17]
      assert book.date_read == ~D[2010-04-17]
      assert book.pages_count == 42
      assert book.publisher == "some publisher"
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, %Book{} = book} = Accounts.update_book(book, @update_attrs)
      assert book.author == "some updated author"
      assert book.authorlf == "some updated authorlf"
      assert book.average_rating == 456.7
      assert book.book_id == 43
      assert book.bookshelves == []
      assert book.date_added == ~D[2011-05-18]
      assert book.date_read == ~D[2011-05-18]
      assert book.pages_count == 43
      assert book.publisher == "some updated publisher"
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_book(book, @invalid_attrs)
      assert book == Accounts.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Accounts.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Accounts.change_book(book)
    end
  end
end
