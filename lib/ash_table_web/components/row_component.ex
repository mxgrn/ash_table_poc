defmodule AshTableWeb.RowComponent do
  use Phoenix.LiveComponent
  import AshTableWeb.CoreComponents
  alias Phoenix.LiveView.JS

  def update(assigns, socket) do
    {:ok, assign(socket, Map.merge(assigns, %{editing_field: assigns[:editing_field]}))}
  end

  def handle_event("start_edit_cell", params, socket) do
    {:noreply, assign(socket, editing_field: params["field"])}
  end

  def handle_event("stop_edit", _params, socket) do
    {:noreply, assign(socket, editing_field: nil)}
  end

  # This only happens when editing_cell is set
  def handle_event("enter", %{"value" => value}, socket) do
    updated_record =
      socket.assigns.record
      |> Ash.Changeset.for_update(:update, %{
        socket.assigns.editing_field => value
      })
      |> AshTable.Library.update!()

    {:noreply, assign(socket, editing_field: nil, record: updated_record)}
  end

  def render(assigns) do
    ~H"""
    <tr class="flex divide-x hover:bg-gray-100" data={[index: @record.id]} id={"tr-#{@record.id}"}>
      <td
        :for={col <- @cols}
        style={"width: #{col.width}px"}
        class={unless col.read_only, do: "cursor-pointer"}
        phx-click={unless col.read_only, do: "start_edit_cell"}
        phx-value-row_id={@record.id}
        phx-value-field={col.name}
        phx-target={@myself}
      >
        <div :if={!(@editing_field == col.name |> to_string)} class="py-1 px-3">
          <%= Map.get(@record, col.name) %>
        </div>
        <div :if={@editing_field == col.name |> to_string}>
          <input
            type="text"
            value={Map.get(@record, col.name)}
            class="p-0 m-0 w-full border-none py-1 px-3 text-sm"
            phx-keydown="enter"
            phx-key="Enter"
            phx-target={@myself}
            phx-focus={JS.dispatch("try_focus")}
            phx-hook="CellEditor"
            id={"input-#{@record.id}"}
            phx-click-away="stop_edit"
          />
        </div>
      </td>
      <td class="inline-flex py-1 px-3" style="width: 20px">
        <.icon name="hero-dots" class="h-3" />
      </td>
    </tr>
    """
  end
end
