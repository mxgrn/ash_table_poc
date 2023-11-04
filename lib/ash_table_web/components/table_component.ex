defmodule AshTableWeb.TableComponent do
  use Phoenix.LiveComponent

  import AshTableWeb.CoreComponents

  @doc """
  Assigns:
    - resource: The Ash resource module
  """
  def update(assigns, socket) do
    resource = assigns.resource
    api = assigns.api

    cols =
      Ash.Resource.Info.fields(resource)
      |> Enum.map(fn attribute ->
        %{
          name: attribute.name,
          title: attribute.name |> to_string |> String.capitalize() |> String.replace("_", " "),
          width: 400,
          sort: if(attribute.name == :inserted_at, do: :asc, else: nil),
          read_only: attribute.name in [:id, :inserted_at, :updated_at]
        }
      end)

    sort =
      Enum.find(cols, fn col -> col[:sort] end)
      |> case do
        nil -> []
        %{name: name, sort: sort_order} -> {name, sort_order}
      end

    records =
      resource
      |> Ash.Query.sort(sort)
      |> api.read!()

    {:ok,
     assign(
       socket,
       Map.merge(assigns, %{
         resource: resource,
         api: api,
         records: records,
         cols: cols,
         editing_cell: %{
           field: nil,
           row_id: nil
         }
       })
     )}
  end

  def render(assigns) do
    ~H"""
    <table
      class="w-1/3 divide-y divide-gray-300 bg-gray-100"
      phx-hook="Resizable"
      id="tableId"
      phx-click-away="stop_edit"
      phx-target={@myself}
    >
      <thead>
        <tr class="flex font-bold divide-x" phx-hook="Sortable" id="head-tr">
          <th
            :for={{col, i} <- @cols |> Enum.with_index()}
            class="inline-flex py-1 px-3 cursor-pointer"
            phx-click="sort"
            phx-value-index={i}
            phx-target={@myself}
            style={"width: #{col.width}px"}
            data={[index: i]}
          >
            <%= col.title %>
            <.sort_icon col={col} />
          </th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200">
        <tr
          :for={{row, i} <- @records |> Enum.with_index()}
          id={"row-#{row.id}"}
          class="flex divide-x"
          data={[index: i]}
        >
          <td
            :for={col <- @cols}
            style={"width: #{col.width}px"}
            class={unless col.read_only, do: "cursor-pointer"}
            phx-click={unless col.read_only, do: "start_edit_cell"}
            phx-value-row_id={row.id}
            phx-value-field={col.name}
            phx-target={@myself}
          >
            <div
              :if={!(@editing_cell.field == col.name && @editing_cell.row_id == to_string(row.id))}
              class="py-1 px-3"
            >
              <%= Map.get(row, col.name) %>
            </div>
            <div :if={@editing_cell.field == col.name && @editing_cell.row_id == to_string(row.id)}>
              <input
                type="text"
                value={Map.get(row, col.name)}
                class="p-0 m-0 w-full border-none py-1 px-3"
                phx-keydown="enter"
                phx-key="Enter"
                phx-change="input_change"
                phx-target={@myself}
                phx-click-away="stop_edit"
              />
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end

  # This only happens when editing_cell is set
  def handle_event("enter", %{"value" => value} = params, socket) do
    params |> dbg

    socket.assigns.resource
    |> AshTable.Library.get!(socket.assigns.editing_cell.row_id)
    |> Ash.Changeset.for_update(:update, %{
      socket.assigns.editing_cell.field => value
    })
    |> AshTable.Library.update!()

    cols = socket.assigns.cols

    sort =
      cols
      |> Enum.find(& &1[:sort])
      |> case do
        nil -> []
        %{name: name, sort: sort_order} -> [{name, sort_order}]
      end

    records =
      socket.assigns.resource
      |> Ash.Query.sort(sort)
      |> socket.assigns.api.read!()

    {:noreply,
     assign(socket,
       editing_cell: %{field: nil, row_id: nil},
       records: records
     )}
  end

  def handle_event("input_change", params, socket) do
    params |> dbg

    {:noreply, socket}
  end

  def handle_event("start_edit_cell", params, socket) do
    params |> dbg

    {:noreply,
     assign(socket,
       editing_cell: %{
         field: params["field"] |> String.to_existing_atom(),
         row_id: params["row_id"]
       }
     )}
  end

  def handle_event("stop_edit", _params, socket) do
    {:noreply, assign(socket, editing_cell: %{field: nil, row_id: nil})}
  end

  def handle_event("sort", %{"index" => index} = params, socket) do
    # Put your logic here to deal with the changes to the list order
    # and persist the data
    params |> dbg

    index = String.to_integer(index)

    # Update the order of the columns in assigns
    cols = socket.assigns.cols

    cols =
      cols
      |> Enum.with_index()
      |> Enum.map(fn {col, i} ->
        if i == index do
          sort_order =
            case col[:sort] do
              nil -> :asc
              :asc -> :desc
              :desc -> nil
            end

          Map.put(col, :sort, sort_order)
        else
          Map.put(col, :sort, nil)
        end
      end)

    sort =
      Enum.find(cols, fn col -> col[:sort] end)
      |> case do
        nil -> []
        %{name: name, sort: sort_order} -> {name, sort_order}
      end

    records =
      socket.assigns.resource
      |> Ash.Query.sort(sort)
      |> socket.assigns.api.read!()

    {:noreply, assign(socket, cols: cols, records: records)}
  end

  def handle_event("reposition", %{"index" => index, "new" => new_index} = params, socket) do
    # Put your logic here to deal with the changes to the list order
    # and persist the data
    params |> dbg

    # Somehow Sortable passes index as a string, as opposed to new_index
    index = String.to_integer(index)

    # Update the order of the columns in assigns
    cols = socket.assigns.cols

    cols =
      cols
      |> Enum.with_index()
      |> Enum.reject(fn {_, i} -> i == index end)
      |> Enum.map(fn {col, _i} -> col end)
      |> List.insert_at(new_index, Enum.at(cols, index))

    {:noreply, assign(socket, cols: cols)}
  end

  def handle_event("resize", %{"width" => width, "index" => index} = params, socket) do
    # Put your logic here to deal with the changes to the list order
    # and persist the data
    params |> dbg

    # Update the width of the column in assigns
    cols = socket.assigns.cols

    cols =
      cols
      |> Enum.with_index()
      |> Enum.map(fn {col, i} ->
        if i == index do
          %{col | width: width}
        else
          col
        end
      end)

    {:noreply, assign(socket, cols: cols)}
  end

  defp sort_icon(assigns) do
    ~H"""
    <span :if={@col[:sort]} class="ml-2 flex-none rounded text-gray-900 group-hover:bg-gray-200">
      <.icon :if={@col[:sort] == :asc} name="hero-arrow-up" class="h-3" />
      <.icon :if={@col[:sort] == :desc} name="hero-arrow-down" class="h-3" />
    </span>
    """
  end
end
