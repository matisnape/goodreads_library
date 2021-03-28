defmodule GoodreadsLibraryWeb.ShelfLive.Show do
  use GoodreadsLibraryWeb, :live_view

  alias GoodreadsLibrary.Books

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shelf, Books.get_shelf!(id))}
  end

  defp page_title(:show), do: "Show Shelf"
  defp page_title(:edit), do: "Edit Shelf"
end
