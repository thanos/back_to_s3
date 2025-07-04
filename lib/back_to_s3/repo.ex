defmodule BackToS3.Repo do
  use Ecto.Repo,
    otp_app: :back_to_s3,
    adapter: Ecto.Adapters.SQLite3
end
