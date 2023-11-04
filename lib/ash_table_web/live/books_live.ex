defmodule AshTableWeb.BooksLive do
  use Phoenix.LiveView
  alias AshTableWeb.TableComponent

  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={TableComponent} resource={AshTable.Book} id="books" />
    </div>
    """
  end
end
