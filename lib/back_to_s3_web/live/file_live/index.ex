defmodule BackToS3Web.FileLive.Index do
  use BackToS3Web, :live_view

  alias BackToS3.Archives

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Files
        <:actions>
          <.button variant="primary" navigate={~p"/files/new"}>
            <.icon name="hero-plus" /> New File
          </.button>
        </:actions>
      </.header>

      <.table
        id="files"
        rows={@streams.files}
        row_click={fn {_id, file} -> JS.navigate(~p"/files/#{file}") end}
      >
        <:col :let={{_id, file}} label="Original file">{file.original_file}</:col>
        <:col :let={{_id, file}} label="S3 key">{file.s3_key}</:col>
        <:col :let={{_id, file}} label="S3 bucket">{file.s3_bucket}</:col>
        <:col :let={{_id, file}} label="Mtime">{file.mtime}</:col>
        <:col :let={{_id, file}} label="Size">{file.size}</:col>
        <:col :let={{_id, file}} label="Md5">{file.md5}</:col>
        <:col :let={{_id, file}} label="S3 etag">{file.s3_etag}</:col>
        <:col :let={{_id, file}} label="Status">{file.status}</:col>
        <:col :let={{_id, file}} label="Error">{file.error}</:col>
        <:col :let={{_id, file}} label="Job">{file.job_id}</:col>
        <:action :let={{_id, file}}>
          <div class="sr-only">
            <.link navigate={~p"/files/#{file}"}>Show</.link>
          </div>
          <.link navigate={~p"/files/#{file}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, file}}>
          <.link
            phx-click={JS.push("delete", value: %{id: file.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Files")
     |> stream(:files, Archives.list_files())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    file = Archives.get_file!(id)
    {:ok, _} = Archives.delete_file(file)

    {:noreply, stream_delete(socket, :files, file)}
  end
end
