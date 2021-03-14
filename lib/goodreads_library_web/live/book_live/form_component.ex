defmodule GoodreadsLibraryWeb.BookLive.FormComponent do
  use GoodreadsLibraryWeb, :live_component

  alias GoodreadsLibrary.Accounts

  @impl true
  def update(%{book: book} = assigns, socket) do
    changeset = Accounts.change_book(book)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"book" => book_params}, socket) do
    changeset =
      socket.assigns.book
      |> Accounts.change_book(book_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"book" => book_params}, socket) do
    save_book(socket, socket.assigns.action, book_params)
  end

  defp save_book(socket, :edit, book_params) do
    case Accounts.update_book(socket.assigns.book, book_params) do
      {:ok, _book} ->
        {:noreply,
         socket
         |> put_flash(:info, "Book updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_book(socket, :new, book_params) do
    case Accounts.create_book(book_params) do
      {:ok, _book} ->
        {:noreply,
         socket
         |> put_flash(:info, "Book created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
