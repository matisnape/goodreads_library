defmodule GoodreadsLibrary.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :authorlf, :string
    field :average_rating, :float
    field :remote_id, :integer
    field :bookshelves, {:array, :string}
    field :date_added, :date
    field :date_read, :date
    field :pages_count, :integer, null: true
    field :publisher, :string, default: "unknown"
    field :title, :string

    timestamps()
  end

  @required_fields ~w(author authorlf average_rating remote_id bookshelves date_added date_read publisher title)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
