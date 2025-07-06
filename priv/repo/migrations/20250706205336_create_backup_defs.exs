defmodule BackToS3.Repo.Migrations.CreateBackupDefs do
  use Ecto.Migration

  def change do
    create table(:backup_defs) do
      add :label, :string
      add :source_path, :string
      add :s3_destination, :string
      add :s3_bucket, :string
      add :cron, :string
      add :last_run, :utc_datetime
      add :when_completed, :utc_datetime
      add :status, :string
      add :on, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
