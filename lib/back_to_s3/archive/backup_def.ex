defmodule BackToS3.Archive.BackupDef do
  use Ecto.Schema
  import Ecto.Changeset

  schema "backup_defs" do
    field :label, :string
    field :source_path, :string
    field :s3_destination, :string
    field :s3_bucket, :string
    field :cron, :string
    field :last_run, :utc_datetime
    field :when_completed, :utc_datetime
    field :status, Ecto.Enum, values: [:running, :succeeded, :failed, :never_run], default: :never_run
    field :on, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(backup_def, attrs) do
    backup_def
    |> cast(attrs, [:label, :source_path, :s3_destination, :s3_bucket, :cron, :last_run, :when_completed, :status, :on])
    |> validate_required([:label, :source_path, :s3_destination, :s3_bucket, :status, :on])
  end
end
