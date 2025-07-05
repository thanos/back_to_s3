defmodule BackToS3.Archives.BackupConfig do
  use Ecto.Schema
  import Ecto.Changeset

  schema "backup_configs" do
    field :label, :string
    field :source_path, :string
    field :destination_path, :string
    field :s3_bucket, :string
    field :is_active, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(backup_config, attrs) do
    backup_config
    |> cast(attrs, [:label, :source_path, :destination_path, :s3_bucket, :is_active])
    |> validate_required([:label, :source_path, :destination_path, :s3_bucket, :is_active])
  end
end
