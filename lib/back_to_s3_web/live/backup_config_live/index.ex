defmodule BackToS3Web.BackupConfigLive.Index do
  use BackToS3Web, :live_view

  alias BackToS3.Archives

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Backup configs
        <:actions>
          <.button variant="primary" navigate={~p"/backup_configs/new"}>
            <.icon name="hero-plus" /> New Backup config
          </.button>
        </:actions>
      </.header>

      <.table
        id="backup_configs"
        rows={@streams.backup_configs}
        row_click={fn {_id, backup_config} -> JS.navigate(~p"/backup_configs/#{backup_config}") end}
      >
        <:col :let={{_id, backup_config}} label="Label">{backup_config.label}</:col>
        <:col :let={{_id, backup_config}} label="Source path">{backup_config.source_path}</:col>
        <:col :let={{_id, backup_config}} label="Destination path">{backup_config.destination_path}</:col>
        <:col :let={{_id, backup_config}} label="S3 bucket">{backup_config.s3_bucket}</:col>
        <:col :let={{_id, backup_config}} label="Is active">{backup_config.is_active}</:col>
        <:action :let={{_id, backup_config}}>
          <div class="sr-only">
            <.link navigate={~p"/backup_configs/#{backup_config}"}>Show</.link>
          </div>
          <.link navigate={~p"/backup_configs/#{backup_config}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, backup_config}}>
          <.link
            phx-click={JS.push("delete", value: %{id: backup_config.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Backup configs")
     |> stream(:backup_configs, Archives.list_backup_configs())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    backup_config = Archives.get_backup_config!(id)
    {:ok, _} = Archives.delete_backup_config(backup_config)

    {:noreply, stream_delete(socket, :backup_configs, backup_config)}
  end
end
