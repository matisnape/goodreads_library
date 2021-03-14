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
    field :pages_count, :integer
    field :publisher, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [
      :author,
      :authorlf,
      :average_rating,
      :remote_id,
      :bookshelves,
      :date_added,
      :date_read,
      :publisher,
      :pages_count,
      :title
    ])
    |> validate_required([
      :author,
      :authorlf,
      :average_rating,
      :remote_id,
      :bookshelves,
      :date_added,
      :date_read,
      :publisher,
      :pages_count,
      :title
    ])
  end
end
