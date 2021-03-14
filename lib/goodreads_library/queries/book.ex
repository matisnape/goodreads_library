defmodule GoodreadsLibrary.Queries.Book do
  import Ecto.Query, warn: false

  alias GoodreadsLibrary.Repo
  alias GoodreadsLibrary.Book

  def list_books do
    Repo.all(Book)
  end

  def get_book(id), do: Repo.one(Book, id)

  def get_by_remote_id(id) do
    Book
    |> where(book_id: ^id)
    |> Repo.one()
  end

  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def from_shelves(books, shelves) do
    books
    |> Enum.filter(fn book ->
      Enum.all?(shelves, &Enum.member?(book.bookshelves, &1))
    end)
  end

  def not_on_shelves(books, shelves) do
    books
    |> Enum.reject(fn book ->
      Enum.any?(shelves, &Enum.member?(book.bookshelves, &1))
    end)
  end

  def with_rating_over(books, rating, order \\ :desc) do
    books
    |> Enum.filter(&(&1.average_rating >= rating))
    |> Enum.sort_by(& &1.average_rating, order)
  end

  def limit(books, limit), do: Enum.take(books, limit)
end
