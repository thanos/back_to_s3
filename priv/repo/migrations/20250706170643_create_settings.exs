defmodule BackToS3.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :group, :string
      add :key, :string
      add :value, :string

      timestamps(type: :utc_datetime)
    end
  end
end
