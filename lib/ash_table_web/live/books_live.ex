defmodule AshTableWeb.BooksLive do
  use Phoenix.LiveView
  import AshTableWeb.TableComponent

  def mount(_params, _session, socket) do
    books = [
      {10, "Foo", 20},
      {20, "Bar", 30},
      {30, "Baz", 40},
      {40, "Quux", 50},
      {50, "Quuz", 60},
      {60, "Corge", 70},
      {70, "Grault", 80},
      {80, "Garply", 90},
      {90, "Waldo", 100},
      {100, "Fred", 110},
      {110, "Plugh", 120},
      {120, "Xyzzy", 130},
      {130, "Thud", 140}
    ]

    {:ok, assign(socket, books: books)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Books</h1>
      <.table data={@books} />
    </div>
    """
  end
end
