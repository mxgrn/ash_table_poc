defmodule AshTableWeb.BooksLive do
  use Phoenix.LiveView
  alias AshTableWeb.TableComponent

  def mount(_params, _session, socket) do
    books = [
      %{id: 1, title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925},
      %{id: 2, title: "The Grapes of Wrath", author: "John Steinbeck", year: 1939},
      %{id: 3, title: "Nineteen Eighty-Four", author: "George Orwell", year: 1949},
      %{id: 4, title: "Ulysses", author: "James Joyce", year: 1922}
    ]

    cols = [
      %{name: :id, title: "ID", width: 100},
      %{name: :title, title: "Title", width: 200},
      %{name: :author, title: "Author", width: 200},
      %{name: :year, title: "Year", width: 100}
    ]

    {:ok, assign(socket, books: books, cols: cols)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={TableComponent} data={@books} cols={@cols} id="books" />
    </div>
    """
  end
end
