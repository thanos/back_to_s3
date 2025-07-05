defmodule BackToS3Web.BackupLive.Show do
  use BackToS3Web, :live_view

  alias BackToS3.Archives

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Backup {@backup.id}
        <:subtitle>This is a backup record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/backups"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/backups/#{@backup}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit backup
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Label">{@backup.label}</:item>
        <:item title="Path">{@backup.path}</:item>
        <:item title="Status">{@backup.status}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Backup")
     |> assign(:backup, Archives.get_backup!(id))}
  end
end
