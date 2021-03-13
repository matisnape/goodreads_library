defmodule GoodreadsLibrary.Repo do
  use Ecto.Repo,
    otp_app: :goodreads_library,
    adapter: Ecto.Adapters.Postgres
end
