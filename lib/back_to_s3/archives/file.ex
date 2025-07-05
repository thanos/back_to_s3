defmodule BackToS3.Archives.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :original_file, :string
    field :s3_key, :string
    field :s3_bucket, :string
    field :mtime, :naive_datetime
    field :size, :integer
    field :md5, :string
    field :s3_etag, :string
    field :status, Ecto.Enum, values: [:pending, :in_process, :done, :failed], default: :pending
    field :error, :string
    field :job_id, :integer

    belongs_to :backup, BackToS3.Archives.Backup

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:original_file, :s3_key, :s3_bucket, :mtime, :size, :md5, :s3_etag, :status, :error, :job_id, :backup])
    |> validate_required([:original_file,:mtime, :size, :md5,  :status, :backup  ])
  end
end
