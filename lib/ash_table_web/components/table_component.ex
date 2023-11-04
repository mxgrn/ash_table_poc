defmodule AshTableWeb.TableComponent do
  use Phoenix.Component

  def table(assigns) do
    ~H"""
    <table>
      <thead>
        <tr>
          <th>Id</th>
          <th>Name</th>
          <th>Age</th>
        </tr>
      </thead>
      <tbody>
        <%= for {id, name, age} <- assigns.data do %>
          <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= age %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end
end
