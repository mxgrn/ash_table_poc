defmodule AshTableWeb.TableComponent do
  use Phoenix.LiveComponent

  import AshTableWeb.CoreComponents
  alias AshTableWeb.RowComponent

  @doc """
  Assigns:
    - resource: The Ash resource module
  """
  def update(assigns, socket) do
    resource = assigns.resource
    api = assigns.api

    cols =
      Ash.Resource.Info.fields(resource)
      |> Enum.reject(fn attribute -> attribute.name in [:id] end)
      |> Enum.map(fn attribute ->
        %{
          name: attribute.name,
          title: attribute.name |> to_string |> String.upcase() |> String.replace("_", " "),
          width: default_width(attribute.type),
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
      class="w-1/3 divide-y divide-gray-300 bg-gray-50"
      phx-hook="Resizable"
      id="tableId"
      phx-click-away="stop_edit"
      phx-target={@myself}
    >
      <thead>
        <tr class="flex divide-x bg-gray-100" phx-hook="Sortable" id="head-tr">
          <th
            :for={{col, i} <- @cols |> Enum.with_index()}
            class="inline-flex py-1 px-3 cursor-pointer font-light"
            phx-click="sort"
            phx-value-index={i}
            phx-target={@myself}
            style={"width: #{col.width}px"}
            data={[index: i]}
          >
            <%= col.title %>
            <.sort_icon col={col} />
          </th>
          <th class="inline-flex py-1 px-3" style="width: 20px"></th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200">
        <.live_component
          :for={record <- @records}
          module={RowComponent}
          id={"row-#{record.id}"}
          record={record}
          cols={@cols}
          editing_cell={@editing_cell}
          phx-click="start_edit_cell"
          phx-value-row_id={record.id}
          parent={@myself}
        />
      </tbody>
    </table>
    """
  end

  def handle_event("sort", %{"index" => index} = _params, socket) do
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

  def handle_event("reposition", %{"index" => index, "new" => new_index} = _params, socket) do
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

  def handle_event("resize", %{"width" => width, "index" => index} = _params, socket) do
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

  defp default_width(Ash.Type.Integer), do: 100
  defp default_width(_), do: 300
end
