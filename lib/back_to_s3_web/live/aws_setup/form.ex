defmodule BackToS3Web.AWSSetup.Form do
alias BackToS3.Archive.AWSSetup
  use BackToS3Web, :live_view

  alias BackToS3.Archive
  alias BackToS3.Archive.AWSSetup

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage AWS setup records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="aws_setup-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:aws_access_key_id]} type="text" label="AWS Access Key ID" />
        <.input field={@form[:aws_secret_access_key]} type="text" label="AWS Secret Access Key" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save AWS setup</.button>
          <.button navigate={return_path(@return_to, @aws_setup)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, _params) do
    {:ok, aws_setup} =  AWSSetup.get()
    dbg(aws_setup)
    socket
    |> assign(:page_title, "Edit AWS aws_setups")
    |> assign(:aws_setup, aws_setup)
    |> assign(:form, to_form(AWSSetup.change(aws_setup)))
  end

  defp apply_action(socket, :new, _params) do
    aws_setup =     %AWSSetup{}
    socket
    |> assign(:page_title, "Edit AWS aws_setups")
    |> assign(:aws_setup, aws_setup)
    |> assign(:form, to_form(AWSSetup.change(aws_setup)))
  end





  @impl true
  def handle_event("validate", %{"aws_setup" => aws_setup_params}, socket) do
    changeset = AWSSetup.change(socket.assigns.aws_setup, aws_setup_params)
    dbg(to_form(changeset, action: :validate) )
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"aws_setup" => aws_setup_params}, socket) do
    save_aws_setup(socket, socket.assigns.live_action, aws_setup_params)
  end

  defp save_aws_setup(socket, :edit, aws_setup_params) do

    case AWSSetup.update(socket.assigns.aws_setup, aws_setup_params) do
      {:ok, aws_setup} ->
        {:noreply,
         socket
         |> put_flash(:info, "aws_setup updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, aws_setup))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset,  action: :validate))}
    end
  end

  defp save_aws_setup(socket, :new, aws_setup_params) do
    dbg(aws_setup_params)
    case AWSSetup.create(aws_setup_params) do
      {:ok, aws_setup} ->

        {:noreply,
         socket
         |> put_flash(:info, "aws_setup created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, aws_setup))}

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg(to_form(changeset, validate: true))
        {:noreply, assign(socket, form: to_form(changeset,  action: :validate))}
    end
  end

  defp return_path("index", _aws_setup), do: ~p"/aws_setups"
  defp return_path("show", aws_setup), do: ~p"/aws_setups/#{aws_setup}"
end
