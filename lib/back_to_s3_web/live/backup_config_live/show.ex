defmodule BackToS3Web.BackupConfigLive.Show do
  use BackToS3Web, :live_view

  alias BackToS3.Archives

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Backup config {@backup_config.id}
        <:subtitle>This is a backup_config record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/backup_configs"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/backup_configs/#{@backup_config}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit backup_config
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Label">{@backup_config.label}</:item>
        <:item title="Source path">{@backup_config.source_path}</:item>
        <:item title="Destination path">{@backup_config.destination_path}</:item>
        <:item title="S3 bucket">{@backup_config.s3_bucket}</:item>
        <:item title="Is active">{@backup_config.is_active}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Backup config")
     |> assign(:backup_config, Archives.get_backup_config!(id))}
  end
end
