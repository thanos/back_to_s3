defmodule BackToS3.Archives.Backup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "backups" do
    field :label, :string
    field :path, :string
    field :status, Ecto.Enum, values: [:pending, :completed, :in_progress, :failed], default: :pending
    # field :label, :string
    # field :source_path, :string
    # field :s3_bucket, :string
    # field :destination_path, :string
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(backup, attrs) do
    backup
    |> cast(attrs, [:label, :path, :status])
    |> validate_required([ :path, :status])
  end
end
