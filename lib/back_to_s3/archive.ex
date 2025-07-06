defmodule BackToS3.Archive do
  @moduledoc """
  The Archive context.
  """

  import Ecto.Query, warn: false
  alias BackToS3.Repo

  alias BackToS3.Archive.Setting


  def get_s3_setup do
    with %{value: id} <- Repo.get_by(Setting, group: "AWS", key: "AWS_ACCESS_KEY_ID"),
    %{value: secret} <- Repo.get_by(Setting, group: "AWS", key: "AWS_SECRET_ACCESS_KEY") do
      {:ok, %{aws_access_key_id: id, aws_secret_access_key: secret}}
    else
      _ -> {:error, "No S3 setup found"}
    end
  end

  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Setting{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %Setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting!(id), do: Repo.get!(Setting, id)

  @doc """
  Creates a setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %Setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

      iex> update_setting(setting, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a setting.

  ## Examples

      iex> delete_setting(setting)
      {:ok, %Setting{}}

      iex> delete_setting(setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.

  ## Examples

      iex> change_setting(setting)
      %Ecto.Changeset{data: %Setting{}}

  """
  def change_setting(%Setting{} = setting, attrs \\ %{}) do
    Setting.changeset(setting, attrs)
  end

  alias BackToS3.Archive.BackupDef

  @doc """
  Returns the list of backup_defs.

  ## Examples

      iex> list_backup_defs()
      [%BackupDef{}, ...]

  """
  def list_backup_defs do
    Repo.all(BackupDef)
  end

  @doc """
  Gets a single backup_def.

  Raises `Ecto.NoResultsError` if the Backup def does not exist.

  ## Examples

      iex> get_backup_def!(123)
      %BackupDef{}

      iex> get_backup_def!(456)
      ** (Ecto.NoResultsError)

  """
  def get_backup_def!(id), do: Repo.get!(BackupDef, id)

  @doc """
  Creates a backup_def.

  ## Examples

      iex> create_backup_def(%{field: value})
      {:ok, %BackupDef{}}

      iex> create_backup_def(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_backup_def(attrs) do
    %BackupDef{}
    |> BackupDef.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a backup_def.

  ## Examples

      iex> update_backup_def(backup_def, %{field: new_value})
      {:ok, %BackupDef{}}

      iex> update_backup_def(backup_def, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_backup_def(%BackupDef{} = backup_def, attrs) do
    backup_def
    |> BackupDef.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a backup_def.

  ## Examples

      iex> delete_backup_def(backup_def)
      {:ok, %BackupDef{}}

      iex> delete_backup_def(backup_def)
      {:error, %Ecto.Changeset{}}

  """
  def delete_backup_def(%BackupDef{} = backup_def) do
    Repo.delete(backup_def)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking backup_def changes.

  ## Examples

      iex> change_backup_def(backup_def)
      %Ecto.Changeset{data: %BackupDef{}}

  """
  def change_backup_def(%BackupDef{} = backup_def, attrs \\ %{}) do
    BackupDef.changeset(backup_def, attrs)
  end
end
