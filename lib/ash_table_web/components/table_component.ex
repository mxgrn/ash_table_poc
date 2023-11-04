defmodule AshTableWeb.TableComponent do
  use Phoenix.LiveComponent

  import AshTableWeb.CoreComponents

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~H"""
    <table class="w-1/3 divide-y divide-gray-300" phx-hook="Resizable" id="tableId">
      <thead>
        <tr class="flex font-bold divide-x" phx-hook="Sortable" id="head-tr">
          <th :for={col <- @cols} class="inline-flex py-1 px-3" style={"width: #{col.width}px"}>
            <%= col.title %>
            <span class="ml-2 flex-none rounded text-gray-900 group-hover:bg-gray-200">
              <.icon name="hero-chevron-up" class="h-3" />
            </span>
          </th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200">
        <tr :for={row <- @data} id={"row-#{row.id}"} class="flex divide-x">
          <td :for={col <- @cols} class="py-1 px-3" style={"width: #{col.width}px"}>
            <%= Map.get(row, col.name) %>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end

  def handle_event("reposition", params, socket) do
    # Put your logic here to deal with the changes to the list order
    # and persist the data
    IO.inspect(params)
    {:noreply, socket}
  end

  def handle_event("resize", params, socket) do
    # Put your logic here to deal with the changes to the list order
    # and persist the data
    IO.inspect(params)
    {:noreply, socket}
  end
end
