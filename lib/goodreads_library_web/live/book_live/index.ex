defmodule GoodreadsLibraryWeb.BookLive.Index do
  use GoodreadsLibraryWeb, :live_view

  alias GoodreadsLibrary.Queries
  alias GoodreadsLibrary.BookView

  # @impl true
  # def render(assigns), do: BookView.render("index.html", assigns)

  # @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :books, list_books())}
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, params)}
  # end

  # defp apply_action(socket, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Books")
  # end

  defp list_books do
    Queries.Book.list_books()
  end
end
