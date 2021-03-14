defmodule GoodreadsLibrary.Actions.Import do
  import Ecto.Changeset

  alias GoodreadsLibrary.Queries
  alias GoodreadsLibrary.Repo
  alias GoodreadsLibrary.Book
  alias GoodreadsLibrary.ErrorTracker

  def run(file) do
    # path = "./priv/csv/goodreads_library_export.csv"
    # path2 = "./priv/csv/goodreadsshort.csv"

    file
    |> parse()
    |> import_to_db()
  end

  defp parse(nil), do: []

  defp parse(file) when is_binary(file) do
    file
    |> File.stream!()
    |> CSV.decode!(separator: ?,, headers: true)
    |> Enum.map(&transform_keys/1)
    |> Enum.map(&parse_to_schema/1)
  end

  defp import_to_db([]), do: :ok

  defp import_to_db(remote_books) do
    remote_ids = Enum.map(remote_books, & &1.remote_id)
    db_books_ids = Queries.Book.list_books() |> Enum.map(& &1.remote_id)

    ids_to_create = remote_ids -- db_books_ids
    db_ids_to_delete = db_books_ids |> Enum.reject(&(&1 in remote_ids))
    ids_to_update = db_books_ids |> Enum.filter(&(&1 in remote_ids))

    Repo.transaction(fn ->
      created = ids_to_create |> Enum.map(&insert_book_to_db(&1, remote_books))
      deleted = db_ids_to_delete |> Enum.map(&delete_book_by_remote_id(&1))

      updated =
        ids_to_update
        |> Enum.map(&update_book_by_remote_id(&1, remote_books))
        |> Enum.filter(fn result ->
          {:ok, {_, map}} = result
          map != %{}
        end)

      db_operations = created ++ deleted ++ updated
      errors = Enum.filter(db_operations, fn r -> elem(r, 0) == :error end)

      if length(errors) > 0 do
        ErrorTracker.capture_message("DB operations failed due to: ", errors)
        Repo.rollback(:db_operations_failed)
      else
        %{new: length(created), updated: length(updated), deleted: length(deleted)}
      end
    end)
  end

  defp insert_book_to_db(remote_id, remote_books) do
    remote_book = remote_books |> Enum.find(fn book -> book.remote_id == remote_id end)

    %Book{}
    |> Book.changeset(remote_book)
    |> Repo.insert()
    |> case do
      {:ok, book} ->
        {:ok, book}

      {:error, _} = error ->
        error
    end
  end

  defp update_book_by_remote_id(remote_id, remote_books) do
    remote_book = remote_books |> Enum.find(fn book -> book.remote_id == remote_id end)

    changeset =
      Queries.Book.get_by_remote_id(remote_id)
      |> Book.changeset(remote_book)

    case Repo.update(changeset) do
      {:ok, book} ->
        {:ok, {book, changeset.changes}}

      {:error, _} = error ->
        error
    end
  end

  defp delete_book_by_remote_id(remote_id) do
    Queries.Book.get_by_remote_id(remote_id)
    |> Repo.delete()
    |> case do
      {:ok, book} ->
        {:ok, book}

      {:error, _} = error ->
        error
    end
  end

  defp transform_keys(map) do
    map
    |> Enum.map(fn {key, value} ->
      new_key = key |> Macro.underscore() |> String.replace([" ", "-"], "") |> String.to_atom()

      {new_key, value}
    end)
    |> Enum.into(%{})
  end

  defp parse_to_schema(book) do
    %{
      author: book.author |> sanitize(),
      authorlf: book.authorlf,
      average_rating: String.to_float(book.average_rating),
      remote_id: String.to_integer(book.book_id),
      bookshelves: String.split(book.bookshelves, ", "),
      date_added: parse_date(book.date_added),
      date_read: parse_date(book.date_read) || parse_date(book.date_added),
      publisher: book.publisher,
      pages_count: book.numberof_pages,
      title: book.title
    }
  end

  defp parse_date(""), do: nil

  defp parse_date(date_str) when is_binary(date_str) do
    date_str |> String.replace(~r/\//, "-") |> Date.from_iso8601!()
  end

  defp parse_date(_), do: {:error, :unparseable}

  defp sanitize(str) when is_binary(str), do: str |> String.replace("  ", " ")
end
