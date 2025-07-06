defmodule BackToS3Web.AWSSetup.Show do
  use BackToS3Web, :live_view

  alias BackToS3.Archive

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        <:subtitle>This is your AWS setup</:subtitle>
        <:actions>
          <.button navigate={~p"/"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/aws-setup/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit setting
          </.button>
        </:actions>
      </.header>


      <h2>AWS Setting</h2>
      <div>
        <p>AWS Access Key ID: {@settings.aws_access_key_id}</p>
        <p>AWS Secret Access Key: {@settings.aws_secret_access_key}</p>
      </div>

        <%!-- <:item title="Key">{@settings.aws_access_key_id}</:item>
        <:item title="Value">{@settings.aws_secret_access_key}</:item> --%>

    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do

    settings  = with {:ok, settings} <- BackToS3.Archive.AWSSetup.get() do
        settings
    else
      {:error, _} ->
        %{
          aws_access_key_id: "",
          aws_secret_access_key: ""
          }
    end
    {:ok,
     socket
     |> assign(:settings, settings)
  }
  end
end
