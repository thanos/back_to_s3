defmodule BackToS3Web.BackupDefLive.Index do
  use BackToS3Web, :live_view

  alias BackToS3.Archive

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Backup defs
        <:actions>
          <.button variant="primary" navigate={~p"/backup_defs/new"}>
            <.icon name="hero-plus" /> New Backup def
          </.button>
        </:actions>
      </.header>

      <.table
        id="backup_defs"
        rows={@streams.backup_defs}
        row_click={fn {_id, backup_def} -> JS.navigate(~p"/backup_defs/#{backup_def}") end}
      >
        <:col :let={{_id, backup_def}} label="Label">{backup_def.label}</:col>
        <:col :let={{_id, backup_def}} label="Status">{backup_def.status}</:col>
        <:col :let={{_id, backup_def}} label="On">{backup_def.on}</:col>
        <%!-- <:col :let={{_id, backup_def}} label="Source path">{backup_def.source_path}</:col>
        <:col :let={{_id, backup_def}} label="S3 destination">{backup_def.s3_destination}</:col>
        <:col :let={{_id, backup_def}} label="S3 bucket">{backup_def.s3_bucket}</:col>
        <:col :let={{_id, backup_def}} label="Cron">{backup_def.cron}</:col> --%>
        <:col :let={{_id, backup_def}} label="Last run">{backup_def.last_run}</:col>
        <:col :let={{_id, backup_def}} label="When completed">{backup_def.when_completed}</:col>

        <:action :let={{_id, backup_def}}>
          <div class="sr-only">
            <.link navigate={~p"/backup_defs/#{backup_def}"}>Show</.link>
          </div>
          <.link navigate={~p"/backup_defs/#{backup_def}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, backup_def}}>
          <.link
            phx-click={JS.push("delete", value: %{id: backup_def.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Backup defs")
     |> stream(:backup_defs, Archive.list_backup_defs())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    backup_def = Archive.get_backup_def!(id)
    {:ok, _} = Archive.delete_backup_def(backup_def)

    {:noreply, stream_delete(socket, :backup_defs, backup_def)}
  end
end
