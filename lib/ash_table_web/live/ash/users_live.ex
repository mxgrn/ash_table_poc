defmodule AshTableWeb.Ash.UsersLive do
  use Phoenix.LiveView
  alias AshTableWeb.TableComponent

  def render(assigns) do
    ~H"""
    <div class="text-lg font-bold">
      Ash table demo/POC
    </div>

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

    <div class="font-bold mt-4">
      Features
    </div>
    <ul class="list-disc pl-4">
      <li>CRUD, including multi-record deletions</li>
      <li>Server-side sorting</li>
      <li>Column resizing</li>
      <li>Column drag-n-drop</li>
      <li>Validations</li>
      <li>Inline editing with a doubleclick (WIP, doesn't support validations)</li>
    </ul>

    <div class="font-bold mt-4">
      Code
    </div>

    <ul class="list-disc pl-4">
      <li>The User resource <a href="" class="underline">definition</a></li>
      <li>The ash_table table <a href="" class="underline">configuration</a></li>
    </ul>
    """
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, :resource_id, params["id"])}
  end
end
