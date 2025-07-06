defmodule BackToS3Web.Plugs.RedirectToSetup do


  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn |> Phoenix.Controller.redirect(to: "/settings")
    end
  end
end
