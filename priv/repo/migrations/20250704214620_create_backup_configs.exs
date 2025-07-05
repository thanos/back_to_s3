defmodule BackToS3.Repo.Migrations.CreateBackupConfigs do
  use Ecto.Migration

  def change do
    create table(:backup_configs) do
      add :label, :string
      add :source_path, :string
      add :destination_path, :string
      add :s3_bucket, :string
      add :is_active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
