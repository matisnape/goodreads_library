defmodule GoodreadsLibrary.Queries.Book do
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
