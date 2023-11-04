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
          <th
            :for={{col, i} <- @cols |> Enum.with_index()}
            class="inline-flex py-1 px-3"
            style={"width: #{col.width}px"}
            data={[index: i]}
          >
            <%= col.title %>
            <span class="ml-2 flex-none rounded text-gray-900 group-hover:bg-gray-200">
              <.icon name="hero-chevron-up" class="h-3" />
            </span>
          </th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200">
        <tr
          :for={{row, i} <- @data |> Enum.with_index()}
          id={"row-#{row.id}"}
          class="flex divide-x"
          data={[index: i]}
        >
          <td :for={col <- @cols} class="py-1 px-3" style={"width: #{col.width}px"}>
            <%= Map.get(row, col.name) %>
          </td>
        </tr>
      </tbody>
    </table>
    """
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
end
