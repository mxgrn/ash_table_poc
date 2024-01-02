defmodule AshTableWeb.FormComponent do
  use Phoenix.LiveComponent
  import AshTableWeb.CoreComponents
  alias Ash.Resource.Info

  # TODO: move out
  use Phoenix.VerifiedRoutes,
    endpoint: AshTableWeb.Endpoint,
    router: AshTableWeb.Router,
    statics: AshTableWeb.static_paths()

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
      if assigns.live_action == :new do
        resource
        |> AshPhoenix.Form.for_create(:create,
          api: api
        )
      else
        assigns.record
        |> AshPhoenix.Form.for_update(:update,
          api: api
        )
      end
      |> to_form()

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
      <.form
        :let={form}
        as={:action}
        for={@form}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
        id={"#{@id}_form"}
      >
        <div class="my-4 grid grid-cols-1 md:grid-cols-2 gap-4">
          <%= render_attributes(assigns, @resource, nil, form) %>
        </div>
        <.button phx-disable-with="Saving...">Save</.button>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params || %{})

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", _, socket) do
    form = socket.assigns.form

    case AshPhoenix.Form.submit(form,
           params: form.source.params,
           force?: true
         ) do
      {:ok, _result} ->
        {:noreply,
         socket
         |> put_flash(:info, "Flash")
         |> push_patch(to: "/#{Info.plural_name(socket.assigns.resource)}")}

      :ok ->
        {:noreply,
         socket
         |> put_flash(:info, "Flash")
         |> push_patch(to: "/#{Info.plural_name(socket.assigns.resource)}")}

      {:error, form} ->
        {:noreply, assign(socket, :form, form)}
    end
  end

  def render_attributes(assigns, _resource, _action, _form) do
    ~H"""
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
    """
  end

  defp render_attribute_input(assigns, attribute, form) do
    assigns = assign(assigns, attribute: attribute, form: form)

    ~H"""
    <.input
      type="text"
      field={@form[@attribute.name]}
      disabled={@attribute.read_only}
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
