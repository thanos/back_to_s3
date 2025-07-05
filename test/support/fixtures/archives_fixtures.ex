defmodule BackToS3.ArchivesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BackToS3.Archives` context.
  """

  @doc """
  Generate a backup.
  """
  def backup_fixture(attrs \\ %{}) do
    {:ok, backup} =
      attrs
      |> Enum.into(%{
        label: "some label",
        path: "some path",
        status: :""
      })
      |> BackToS3.Archives.create_backup()

    backup
  end

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        error: "some error",
        job_id: 42,
        md5: "some md5",
        mtime: ~N[2025-07-03 18:09:00],
        original_file: "some original_file",
        s3_bucket: "some s3_bucket",
        s3_etag: "some s3_etag",
        s3_key: "some s3_key",
        size: 42,
        status: :pending
      })
      |> BackToS3.Archives.create_file()

    file
  end

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        error: "some error",
        job_id: 42,
        md5: "some md5",
        mtime: ~N[2025-07-03 18:11:00],
        original_file: "some original_file",
        s3_bucket: "some s3_bucket",
        s3_etag: "some s3_etag",
        s3_key: "some s3_key",
        size: 42,
        status: :pending
      })
      |> BackToS3.Archives.create_file()

    file
  end

  @doc """
  Generate a backup_config.
  """
  def backup_config_fixture(attrs \\ %{}) do
    {:ok, backup_config} =
      attrs
      |> Enum.into(%{
        destination_path: "some destination_path",
        is_active: true,
        label: "some label",
        s3_bucket: "some s3_bucket",
        source_path: "some source_path"
      })
      |> BackToS3.Archives.create_backup_config()

    backup_config
  end
end
