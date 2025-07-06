defmodule BackToS3.Archive.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settings" do
    field :group, :string
    field :key, :string
    field :value, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:group, :key, :value])
    |> validate_required([:group, :key, :value])
  end
end
