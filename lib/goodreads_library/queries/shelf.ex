defmodule GoodreadsLibrary.Queries.Shelf do
  import Ecto.Query, warn: false

  alias GoodreadsLibrary.Repo
  alias GoodreadsLibrary.Shelf

  def list_Shelfs do
    Repo.all(Shelf)
  end

  def get_Shelf(id), do: Repo.one(Shelf, id)
end
