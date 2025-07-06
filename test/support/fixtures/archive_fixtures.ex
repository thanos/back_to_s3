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
end
