defmodule BackToS3.ArchiveFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BackToS3.Archive` context.
  """

  @doc """
  Generate a setting.
  """
  def setting_fixture(attrs \\ %{}) do
    {:ok, setting} =
      attrs
      |> Enum.into(%{
        group: "some group",
        key: "some key",
        value: "some value"
      })
      |> BackToS3.Archive.create_setting()

    setting
  end

  @doc """
  Generate a backup_def.
  """
  def backup_def_fixture(attrs \\ %{}) do
    {:ok, backup_def} =
      attrs
      |> Enum.into(%{
        cron: "some cron",
        label: "some label",
        last_run: ~U[2025-07-05 20:53:00Z],
        on: true,
        s3_bucket: "some s3_bucket",
        s3_destination: "some s3_destination",
        source_path: "some source_path",
        status: :running,
        when_completed: ~U[2025-07-05 20:53:00Z]
      })
      |> BackToS3.Archive.create_backup_def()

    backup_def
  end
end
