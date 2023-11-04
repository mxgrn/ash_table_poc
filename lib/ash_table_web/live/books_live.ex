defmodule AshTableWeb.BooksLive do
  use Phoenix.LiveView
  alias AshTableWeb.TableComponent

  def render(assigns) do
    ~H"""
    <div>
      <.live_component
        module={TableComponent}
        resource={AshTable.Book}
        api={AshTable.Library}
        id="books"
      />
    </div>

    <h3 class="text-xl mt-4">Features</h3>
    <ul>
      <li>
        - Moving and resizing columns
      </li>
      <li>
        - Sorting by clicking on column headers
      </li>
      <li>
        - Editing cells
      </li>
    </ul>

    <h3 class="text-xl mt-4">Known issues</h3>
    <ul>
      <li>
        - Resizing columns triggers sorting
      </li>
    </ul>
    """
  end
end
