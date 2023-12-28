defmodule AshTableWeb.FormComponent do
  use Phoenix.LiveComponent
  import AshTableWeb.CoreComponents
  alias Ash.Resource.Info

  def update(assigns, socket) do
    resource = assigns.resource
    api = assigns.api

    fields =
      Info.fields(resource)
      |> Enum.reject(fn attribute -> attribute.name in [:id] end)
      |> Enum.map(fn attribute ->
        %{
          name: attribute.name,
          title: attribute.name |> to_string |> String.upcase() |> String.replace("_", " "),
          read_only: attribute.name in [:id, :inserted_at, :updated_at]
        }
      end)

    form =
      resource
      |> AshPhoenix.Form.for_create(:create,
        api: api
        # actor: socket.assigns[:actor],
        # authorize?: socket.assigns[:authorizing],
        # forms: auto_forms,
        # transform_errors: transform_errors,
        # tenant: socket.assigns[:tenant]
      )

    {:ok,
     assign(
       socket,
       Map.merge(assigns, %{
         resource: resource,
         api: api,
         fields: fields,
         form: form
       })
     )}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.header>New <%= Info.short_name(@resource) %></.header>
      <div class="mt-4 grid grid-cols-1 md:grid-cols-2 gap-4">
        <div :for={attribute <- @fields} class="col-span-1">
          <div phx-feedback-for={@form.name <> "[#{attribute.name}]"}>
            <label
              class="block text-sm font-medium text-gray-700"
              for={@form.name <> "[#{attribute.name}]"}
            >
              <%= to_name(attribute.name) %>
            </label>
            <%= render_attribute_input(assigns, attribute, @form) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp render_attribute_input(assigns, attribute, form) do
    assigns = assign(assigns, attribute: attribute, form: form)

    ~H"""
    <.input
      type="text"
      value=""
      name={@name || @form.name <> "[#{@attribute.name}]"}
      class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
    />
    """
  end

  def to_name(:id), do: "ID"

  def to_name(name) do
    name
    |> to_string()
    |> String.split("_")
    |> Enum.map_join(" ", &String.capitalize/1)
  end
end
