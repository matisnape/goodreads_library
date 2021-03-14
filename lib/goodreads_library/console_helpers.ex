defmodule GoodreadsLibrary.ConsoleHelpers do
  defmacro __using__(_) do
    quote do
      import Ecto.Query
      import Ecto.Changeset

      alias GoodreadsLibrary.Repo
      alias GoodreadsLibrary.Queries
      alias GoodreadsLibrary.Book
      alias GoodreadsLibrary.Actions.Import
    end
  end
end
