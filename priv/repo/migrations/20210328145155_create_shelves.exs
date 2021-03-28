defmodule GoodreadsLibrary.Repo.Migrations.CreateShelves do
  use Ecto.Migration

  def change do
    create table(:shelves) do
      add :name, :string

      timestamps()
    end

  end
end
