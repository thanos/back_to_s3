defmodule BackToS3Web.BackupLive.Form do
  use BackToS3Web, :live_view

  alias BackToS3.Archives
  alias BackToS3.Archives.Backup

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage backup records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="backup-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:label]} type="text" label="Label" />
        <.input field={@form[:path]} type="textarea" label="Path" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(BackToS3.Archives.Backup, :status)}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Backup</.button>
          <.button navigate={return_path(@return_to, @backup)}>Cancel</.button>
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
    backup = Archives.get_backup!(id)

    socket
    |> assign(:page_title, "Edit Backup")
    |> assign(:backup, backup)
    |> assign(:form, to_form(Archives.change_backup(backup)))
  end

  defp apply_action(socket, :new, _params) do
    backup = %Backup{}

    socket
    |> assign(:page_title, "New Backup")
    |> assign(:backup, backup)
    |> assign(:form, to_form(Archives.change_backup(backup)))
  end

  @impl true
  def handle_event("validate", %{"backup" => backup_params}, socket) do
    changeset = Archives.change_backup(socket.assigns.backup, backup_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"backup" => backup_params}, socket) do
    save_backup(socket, socket.assigns.live_action, backup_params)
  end

  defp save_backup(socket, :edit, backup_params) do
    case Archives.update_backup(socket.assigns.backup, backup_params) do
      {:ok, backup} ->
        {:noreply,
         socket
         |> put_flash(:info, "Backup updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, backup))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_backup(socket, :new, backup_params) do
    case Archives.create_backup(backup_params) do
      {:ok, backup} ->
        {:noreply,
         socket
         |> put_flash(:info, "Backup created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, backup))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _backup), do: ~p"/backups"
  defp return_path("show", backup), do: ~p"/backups/#{backup}"
end
