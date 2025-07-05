defmodule BackToS3Web.BackupLive.Index do
  use BackToS3Web, :live_view

  alias BackToS3.Archives

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Backups
        <:actions>
          <.button variant="primary" navigate={~p"/backups/new"}>
            <.icon name="hero-plus" /> New Backup
          </.button>
        </:actions>
      </.header>

      <.table
        id="backups"
        rows={@streams.backups}
        row_click={fn {_id, backup} -> JS.navigate(~p"/backups/#{backup}") end}
      >
        <:col :let={{_id, backup}} label="Label">{backup.label}</:col>
        <:col :let={{_id, backup}} label="Path">{backup.path}</:col>
        <:col :let={{_id, backup}} label="Status">{backup.status}</:col>
        <:action :let={{_id, backup}}>
          <div class="sr-only">
            <.link navigate={~p"/backups/#{backup}"}>Show</.link>
          </div>
          <.link navigate={~p"/backups/#{backup}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, backup}}>
          <.link
            phx-click={JS.push("delete", value: %{id: backup.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Backups")
     |> stream(:backups, Archives.list_backups())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    backup = Archives.get_backup!(id)
    {:ok, _} = Archives.delete_backup(backup)

    {:noreply, stream_delete(socket, :backups, backup)}
  end
end
