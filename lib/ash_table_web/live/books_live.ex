defmodule AshTableWeb.BooksLive do
  use Phoenix.LiveView
  alias AshTableWeb.TableComponent

  def mount(_params, _session, socket) do
    {:ok, books} = AshTable.Book.read_all()

    cols =
      Ash.Resource.Info.fields(AshTable.Book)
      |> Enum.map(fn attribute ->
        %{
          name: attribute.name,
          title: attribute.name |> to_string |> String.upcase(),
          width: 400
        }
      end)

    {:ok, assign(socket, books: books, cols: cols)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={TableComponent} data={@books} cols={@cols} id="books" />
    </div>
    """
  end
end
