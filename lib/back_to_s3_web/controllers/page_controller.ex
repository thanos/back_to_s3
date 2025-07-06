defmodule BackToS3Web.PageController do
  use BackToS3Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    with {:ok, _} <- BackToS3.Archive.AWSSetup.get do
      render(conn, :home, layout: false)
    else
      {:error, _} ->
        conn |> Phoenix.Controller.redirect(to: "/aws-setup/new", return_to: "/")
    end


  end
end
