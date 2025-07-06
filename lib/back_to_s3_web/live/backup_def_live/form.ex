defmodule BackToS3Web.BackupDefLive.Form do
  use BackToS3Web, :live_view

  alias BackToS3.Archive
  alias BackToS3.Archive.BackupDef

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage backup_def records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="backup_def-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:label]} type="text" label="Label" />
        <.input field={@form[:source_path]} type="text" label="Source path" />
        <.input field={@form[:s3_destination]} type="text" label="S3 destination" />
        <.input field={@form[:s3_bucket]} type="text" label="S3 bucket" />
        <.input field={@form[:cron]} type="text" label="Cron" />
        <.input field={@form[:last_run]} type="datetime-local" label="Last run" />
        <.input field={@form[:when_completed]} type="datetime-local" label="When completed" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(BackToS3.Archive.BackupDef, :status)}
        />
        <.input field={@form[:on]} type="checkbox" label="On" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Backup def</.button>
          <.button navigate={return_path(@return_to, @backup_def)}>Cancel</.button>
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
    backup_def = Archive.get_backup_def!(id)

    socket
    |> assign(:page_title, "Edit Backup def")
    |> assign(:backup_def, backup_def)
    |> assign(:form, to_form(Archive.change_backup_def(backup_def)))
  end

  defp apply_action(socket, :new, _params) do
    backup_def = %BackupDef{}

    socket
    |> assign(:page_title, "New Backup def")
    |> assign(:backup_def, backup_def)
    |> assign(:form, to_form(Archive.change_backup_def(backup_def)))
  end

  @impl true
  def handle_event("validate", %{"backup_def" => backup_def_params}, socket) do
    changeset = Archive.change_backup_def(socket.assigns.backup_def, backup_def_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"backup_def" => backup_def_params}, socket) do
    save_backup_def(socket, socket.assigns.live_action, backup_def_params)
  end

  defp save_backup_def(socket, :edit, backup_def_params) do
    case Archive.update_backup_def(socket.assigns.backup_def, backup_def_params) do
      {:ok, backup_def} ->
        {:noreply,
         socket
         |> put_flash(:info, "Backup def updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, backup_def))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_backup_def(socket, :new, backup_def_params) do
    case Archive.create_backup_def(backup_def_params) do
      {:ok, backup_def} ->
        {:noreply,
         socket
         |> put_flash(:info, "Backup def created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, backup_def))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _backup_def), do: ~p"/backup_defs"
  defp return_path("show", backup_def), do: ~p"/backup_defs/#{backup_def}"
end
