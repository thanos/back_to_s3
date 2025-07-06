defmodule BackToS3Web.SettingLive.Show do
  use BackToS3Web, :live_view

  alias BackToS3.Archive

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Setting {@setting.id}
        <:subtitle>This is a setting record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/settings"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/settings/#{@setting}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit setting
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Group">{@setting.group}</:item>
        <:item title="Key">{@setting.key}</:item>
        <:item title="Value">{@setting.value}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Setting")
     |> assign(:setting, Archive.get_setting!(id))}
  end
end
