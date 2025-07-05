defmodule BackToS3Web.FileLive.Show do
  use BackToS3Web, :live_view

  alias BackToS3.Archives

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        File {@file.id}
        <:subtitle>This is a file record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/files"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/files/#{@file}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit file
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Original file">{@file.original_file}</:item>
        <:item title="S3 key">{@file.s3_key}</:item>
        <:item title="S3 bucket">{@file.s3_bucket}</:item>
        <:item title="Mtime">{@file.mtime}</:item>
        <:item title="Size">{@file.size}</:item>
        <:item title="Md5">{@file.md5}</:item>
        <:item title="S3 etag">{@file.s3_etag}</:item>
        <:item title="Status">{@file.status}</:item>
        <:item title="Error">{@file.error}</:item>
        <:item title="Job">{@file.job_id}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show File")
     |> assign(:file, Archives.get_file!(id))}
  end
end
