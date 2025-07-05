defmodule BackToS3Web.Router do
  use BackToS3Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BackToS3Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BackToS3Web do
    pipe_through :browser

    get "/", PageController, :home


    live "/backup_configs", BackupConfigLive.Index, :index
    live "/backup_configs/new", BackupConfigLive.Form, :new
    live "/backup_configs/:id", BackupConfigLive.Show, :show
    live "/backup_configs/:id/edit", BackupConfigLive.Form, :edit

    live "/backups", BackupLive.Index, :index
    live "/backups/new", BackupLive.Form, :new
    live "/backups/:id", BackupLive.Show, :show
    live "/backups/:id/edit", BackupLive.Form, :edit


    live "/files", FileLive.Index, :index
    live "/files/new", FileLive.Form, :new
    live "/files/:id", FileLive.Show, :show
    live "/files/:id/edit", FileLive.Form, :edit


  end

  # Other scopes may use custom stacks.
  # scope "/api", BackToS3Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:back_to_s3, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BackToS3Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
