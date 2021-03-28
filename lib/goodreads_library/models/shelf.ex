defmodule GoodreadsLibrary.Shelf do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shelves" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(shelf, attrs) do
    shelf
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
