defmodule BackToS3Web.BackupConfigLive.Form do
  use BackToS3Web, :live_view

  alias BackToS3.Archives
  alias BackToS3.Archives.BackupConfig

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage backup_config records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="backup_config-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:label]} type="text" label="Label" />
        <.input field={@form[:source_path]} type="text" label="Source path" />
        <.input field={@form[:destination_path]} type="text" label="Destination path" />
        <.input field={@form[:s3_bucket]} type="text" label="S3 bucket" />
        <.input field={@form[:is_active]} type="checkbox" label="Is active" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Backup config</.button>
          <.button navigate={return_path(@return_to, @backup_config)}>Cancel</.button>
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
    backup_config = Archives.get_backup_config!(id)

    socket
    |> assign(:page_title, "Edit Backup config")
    |> assign(:backup_config, backup_config)
    |> assign(:form, to_form(Archives.change_backup_config(backup_config)))
  end

  defp apply_action(socket, :new, _params) do
    backup_config = %BackupConfig{}

    socket
    |> assign(:page_title, "New Backup config")
    |> assign(:backup_config, backup_config)
    |> assign(:form, to_form(Archives.change_backup_config(backup_config)))
  end

  @impl true
  def handle_event("validate", %{"backup_config" => backup_config_params}, socket) do
    changeset = Archives.change_backup_config(socket.assigns.backup_config, backup_config_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"backup_config" => backup_config_params}, socket) do
    save_backup_config(socket, socket.assigns.live_action, backup_config_params)
  end

  defp save_backup_config(socket, :edit, backup_config_params) do
    case Archives.update_backup_config(socket.assigns.backup_config, backup_config_params) do
      {:ok, backup_config} ->
        {:noreply,
         socket
         |> put_flash(:info, "Backup config updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, backup_config))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_backup_config(socket, :new, backup_config_params) do
    case Archives.create_backup_config(backup_config_params) do
      {:ok, backup_config} ->
        {:noreply,
         socket
         |> put_flash(:info, "Backup config created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, backup_config))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _backup_config), do: ~p"/backup_configs"
  defp return_path("show", backup_config), do: ~p"/backup_configs/#{backup_config}"
end
