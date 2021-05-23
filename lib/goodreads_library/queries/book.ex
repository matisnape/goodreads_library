defmodule GoodreadsLibrary.Queries.Book do
  import Ecto.Query, warn: false

  alias GoodreadsLibrary.Repo
  alias GoodreadsLibrary.Book

  def list_books do
    Repo.all(Book)
  end

  def list_shelves do
    Book
    |> select([b], b.bookshelves)
    |> Repo.all()
    |> List.flatten()
    |> Enum.uniq()
  end

  def get_book(id), do: Repo.one(Book, id)

  def get_by_remote_id(id) do
    Book
    |> where(remote_id: ^id)
    |> Repo.one()
  end

  def get_read do
    Book
    |> where([b], b.read_count >= 1)
    |> Repo.all()
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
