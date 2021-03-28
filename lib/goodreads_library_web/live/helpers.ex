defmodule GoodreadsLibraryWeb.Helpers do
  def cover_preview(%{remote_id: _remote_id}) do
    # example
    # https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1487351616l/34068480.jpg
    # I don't know from where `1487351616l` comes from,
    # so you'll need to scrap this somehow from html
    # by looking for book ID in element starting with `<img id="coverImage"`
    # maybe this doesn't change
  end
end
