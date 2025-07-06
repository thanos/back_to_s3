defmodule BackToS3Web.SettingLive.Form do
  use BackToS3Web, :live_view

  alias BackToS3.Archive
  alias BackToS3.Archive.Setting

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage setting records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="setting-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:group]} type="text" label="Group" />
        <.input field={@form[:key]} type="text" label="Key" />
        <.input field={@form[:value]} type="text" label="Value" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Setting</.button>
          <.button navigate={return_path(@return_to, @setting)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    setting = Archive.get_setting!(id)

    socket
    |> assign(:page_title, "Edit Setting")
    |> assign(:setting, setting)
    |> assign(:form, to_form(Archive.change_setting(setting)))
  end

  defp apply_action(socket, :new, _params) do
    setting = %Setting{}

    socket
    |> assign(:page_title, "New Setting")
    |> assign(:setting, setting)
    |> assign(:form, to_form(Archive.change_setting(setting)))
  end

  @impl true
  def handle_event("validate", %{"setting" => setting_params}, socket) do
    changeset = Archive.change_setting(socket.assigns.setting, setting_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"setting" => setting_params}, socket) do
    save_setting(socket, socket.assigns.live_action, setting_params)
  end

  defp save_setting(socket, :edit, setting_params) do
    case Archive.update_setting(socket.assigns.setting, setting_params) do
      {:ok, setting} ->
        {:noreply,
         socket
         |> put_flash(:info, "Setting updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, setting))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_setting(socket, :new, setting_params) do
    case Archive.create_setting(setting_params) do
      {:ok, setting} ->
        {:noreply,
         socket
         |> put_flash(:info, "Setting created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, setting))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _setting), do: ~p"/settings"
  defp return_path("show", setting), do: ~p"/settings/#{setting}"
end
