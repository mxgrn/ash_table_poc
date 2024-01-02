defmodule AshTableWeb.Ash.BooksLive do
  use Phoenix.LiveView
  alias AshTableWeb.TableComponent

  def render(assigns) do
    ~H"""
    <div>
      <.live_component
        module={TableComponent}
        resource={AshTable.Book}
        api={AshTable.Library}
        live_action={@live_action}
        resource_id={@resource_id}
        id="books"
      />
    </div>
    """
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, :resource_id, params["id"])}
  end
end
