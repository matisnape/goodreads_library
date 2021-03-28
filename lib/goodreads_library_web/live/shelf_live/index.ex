defmodule GoodreadsLibraryWeb.ShelfLive.Index do
  use GoodreadsLibraryWeb, :live_view

  alias GoodreadsLibrary.Books
  alias GoodreadsLibrary.Queries.Shelf

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :shelves, list_shelves())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shelves")
    |> assign(:shelf, nil)
  end

  defp list_shelves do
    Shelf.list_shelves()
  end
end
