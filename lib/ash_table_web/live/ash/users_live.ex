defmodule AshTableWeb.Ash.UsersLive do
  use Phoenix.LiveView
  alias AshTableWeb.TableComponent

  def render(assigns) do
    ~H"""
    <div>
      <.live_component
        module={TableComponent}
        resource={AshTable.User}
        api={AshTable.Ash.Users}
        live_action={@live_action}
        resource_id={@resource_id}
        id="users"
      />
    </div>
    """
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, :resource_id, params["id"])}
  end
end
