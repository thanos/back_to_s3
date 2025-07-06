defmodule BackToS3Web.BackupDefLive.Show do
  use BackToS3Web, :live_view

  alias BackToS3.Archive

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Backup def {@backup_def.id}
        <:subtitle>This is a backup_def record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/backup_defs"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/backup_defs/#{@backup_def}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit backup_def
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Label">{@backup_def.label}</:item>
        <:item title="Source path">{@backup_def.source_path}</:item>
        <:item title="S3 destination">{@backup_def.s3_destination}</:item>
        <:item title="S3 bucket">{@backup_def.s3_bucket}</:item>
        <:item title="Cron">{@backup_def.cron}</:item>
        <:item title="Last run">{@backup_def.last_run}</:item>
        <:item title="When completed">{@backup_def.when_completed}</:item>
        <:item title="Status">{@backup_def.status}</:item>
        <:item title="On">{@backup_def.on}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Backup def")
     |> assign(:backup_def, Archive.get_backup_def!(id))}
  end
end
