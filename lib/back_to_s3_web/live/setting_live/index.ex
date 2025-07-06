defmodule BackToS3Web.SettingLive.Index do
  use BackToS3Web, :live_view

  alias BackToS3.Archive

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Settings
        <:actions>
          <.button variant="primary" navigate={~p"/settings/new"}>
            <.icon name="hero-plus" /> New Setting
          </.button>
        </:actions>
      </.header>

      <.table
        id="settings"
        rows={@streams.settings}
        row_click={fn {_id, setting} -> JS.navigate(~p"/settings/#{setting}") end}
      >
        <:col :let={{_id, setting}} label="Group">{setting.group}</:col>
        <:col :let={{_id, setting}} label="Key">{setting.key}</:col>
        <:col :let={{_id, setting}} label="Value">{setting.value}</:col>
        <:action :let={{_id, setting}}>
          <div class="sr-only">
            <.link navigate={~p"/settings/#{setting}"}>Show</.link>
          </div>
          <.link navigate={~p"/settings/#{setting}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, setting}}>
          <.link
            phx-click={JS.push("delete", value: %{id: setting.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Settings")
     |> stream(:settings, Archive.list_settings())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    setting = Archive.get_setting!(id)
    {:ok, _} = Archive.delete_setting(setting)

    {:noreply, stream_delete(socket, :settings, setting)}
  end
end
