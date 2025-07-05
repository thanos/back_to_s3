defmodule BackToS3Web.FileLive.Form do
  use BackToS3Web, :live_view

  alias BackToS3.Archives
  alias BackToS3.Archives.File

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage file records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="file-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:original_file]} type="textarea" label="Original file" />
        <.input field={@form[:s3_key]} type="text" label="S3 key" />
        <.input field={@form[:s3_bucket]} type="text" label="S3 bucket" />
        <.input field={@form[:mtime]} type="datetime-local" label="Mtime" />
        <.input field={@form[:size]} type="number" label="Size" />
        <.input field={@form[:md5]} type="text" label="Md5" />
        <.input field={@form[:s3_etag]} type="text" label="S3 etag" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(BackToS3.Archives.File, :status)}
        />
        <.input field={@form[:error]} type="textarea" label="Error" />
        <.input field={@form[:job_id]} type="number" label="Job" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save File</.button>
          <.button navigate={return_path(@return_to, @file)}>Cancel</.button>
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
    file = Archives.get_file!(id)

    socket
    |> assign(:page_title, "Edit File")
    |> assign(:file, file)
    |> assign(:form, to_form(Archives.change_file(file)))
  end

  defp apply_action(socket, :new, _params) do
    file = %File{}

    socket
    |> assign(:page_title, "New File")
    |> assign(:file, file)
    |> assign(:form, to_form(Archives.change_file(file)))
  end

  @impl true
  def handle_event("validate", %{"file" => file_params}, socket) do
    changeset = Archives.change_file(socket.assigns.file, file_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"file" => file_params}, socket) do
    save_file(socket, socket.assigns.live_action, file_params)
  end

  defp save_file(socket, :edit, file_params) do
    case Archives.update_file(socket.assigns.file, file_params) do
      {:ok, file} ->
        {:noreply,
         socket
         |> put_flash(:info, "File updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, file))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_file(socket, :new, file_params) do
    case Archives.create_file(file_params) do
      {:ok, file} ->
        {:noreply,
         socket
         |> put_flash(:info, "File created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, file))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _file), do: ~p"/files"
  defp return_path("show", file), do: ~p"/files/#{file}"
end
