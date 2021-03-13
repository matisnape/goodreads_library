defmodule GoodreadsLibrary.Actions.Import do
  def parse(file) do
    # path = "./priv/csv/goodreads_library_export.csv"
    # path2 = "./priv/csv/goodreadsshort.csv"

    file
    |> File.stream!()
    |> CSV.decode!(separator: ?,, headers: true)
    |> Enum.map(&transform_keys/1)
    |> Enum.map(fn book ->
      %{
        author: book.author,
        authorlf: book.authorlf,
        average_rating: String.to_float(book.average_rating),
        book_id: String.to_integer(book.book_id),
        bookshelves: String.split(book.bookshelves, ", "),
        date_added: book.date_added,
        date_read: book.date_added,
        publisher: book.publisher,
        pages_count: book.numberof_pages,
        title: book.title
      }
    end)
  end

  def transform_keys(map) do
    map
    |> Enum.map(fn {key, value} ->
      new_key = key |> Macro.underscore() |> String.replace([" ", "-"], "") |> String.to_atom()

      {new_key, value}
    end)
    |> Enum.into(%{})
  end
end
