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
      <li>Multi-row selection</li>
      <li>CRUD, including multi-record deletions</li>
      <li>Server-side sorting</li>
      <li>Column resizing (tbd: persistence)</li>
      <li>Column reordering via drag-n-drop (tbd: persistence)</li>
      <li>Form validations (e.g. email format or uniqueness)</li>
      <li>Inline editing, by doubleclick then "Enter" (tbd: support validations)</li>
    </ul>

    <div class="font-bold mt-4">
      Code
    </div>

    <ul class="list-disc pl-4">
      <li>
        The User resource
        <a
          href="https://github.com/mxgrn/ash_table_poc/blob/master/lib/ash_table/ash/users/resources/user.ex"
          class="underline"
          target="_blank"
        >
          definition
        </a>
      </li>
      <li>
        The ash_table table
        <a
          href="https://github.com/mxgrn/ash_table_poc/blob/master/lib/ash_table_web/live/ash/users_live.ex#L12-L19"
          class="underline"
          target="_blank"
        >
          usage
        </a>
      </li>
    </ul>
    """
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, :resource_id, params["id"])}
  end
end
