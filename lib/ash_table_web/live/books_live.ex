defmodule AshTableWeb.BooksLive do
  use Phoenix.LiveView
  alias AshTableWeb.TableComponent
  # import AshTableWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div>
      <.live_component
        module={TableComponent}
        resource={AshTable.Book}
        api={AshTable.Library}
        live_action={@live_action}
        id="books"
      />
    </div>
    """
  end

  def handle_params(params, _url, socket) do
    if params == %{} do
    else
      send_update(TableComponent, %{id: "books", action: "new"})
    end

    {:noreply, socket}
  end
end
