defmodule BackToS3.Archives do
  @moduledoc """
  The Archives context.
  """

  import Ecto.Query, warn: false
  alias BackToS3.Repo

  alias BackToS3.Archives.Backup

  @doc """
  Returns the list of backups.

  ## Examples

      iex> list_backups()
      [%Backup{}, ...]

  """
  def list_backups do
    Repo.all(Backup)
  end

  @doc """
  Gets a single backup.

  Raises `Ecto.NoResultsError` if the Backup does not exist.

  ## Examples

      iex> get_backup!(123)
      %Backup{}

      iex> get_backup!(456)
      ** (Ecto.NoResultsError)

  """
  def get_backup!(id), do: Repo.get!(Backup, id)

  @doc """
  Creates a backup.

  ## Examples

      iex> create_backup(%{field: value})
      {:ok, %Backup{}}

      iex> create_backup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_backup(attrs) do
    %Backup{}
    |> Backup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a backup.

  ## Examples

      iex> update_backup(backup, %{field: new_value})
      {:ok, %Backup{}}

      iex> update_backup(backup, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_backup(%Backup{} = backup, attrs) do
    backup
    |> Backup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a backup.

  ## Examples

      iex> delete_backup(backup)
      {:ok, %Backup{}}

      iex> delete_backup(backup)
      {:error, %Ecto.Changeset{}}

  """
  def delete_backup(%Backup{} = backup) do
    Repo.delete(backup)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking backup changes.

  ## Examples

      iex> change_backup(backup)
      %Ecto.Changeset{data: %Backup{}}

  """
  def change_backup(%Backup{} = backup, attrs \\ %{}) do
    Backup.changeset(backup, attrs)
  end

  alias BackToS3.Archives.File

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  def list_files do
    Repo.all(File)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file!(id), do: Repo.get!(File, id)

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file(attrs) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file(%File{} = file, attrs) do
    file
    |> File.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{data: %File{}}

  """
  def change_file(%File{} = file, attrs \\ %{}) do
    File.changeset(file, attrs)
  end

  alias BackToS3.Archives.BackupConfig

  @doc """
  Returns the list of backup_configs.

  ## Examples

      iex> list_backup_configs()
      [%BackupConfig{}, ...]

  """
  def list_backup_configs do
    Repo.all(BackupConfig)
  end

  @doc """
  Gets a single backup_config.

  Raises `Ecto.NoResultsError` if the Backup config does not exist.

  ## Examples

      iex> get_backup_config!(123)
      %BackupConfig{}

      iex> get_backup_config!(456)
      ** (Ecto.NoResultsError)

  """
  def get_backup_config!(id), do: Repo.get!(BackupConfig, id)

  @doc """
  Creates a backup_config.

  ## Examples

      iex> create_backup_config(%{field: value})
      {:ok, %BackupConfig{}}

      iex> create_backup_config(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_backup_config(attrs) do
    %BackupConfig{}
    |> BackupConfig.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a backup_config.

  ## Examples

      iex> update_backup_config(backup_config, %{field: new_value})
      {:ok, %BackupConfig{}}

      iex> update_backup_config(backup_config, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_backup_config(%BackupConfig{} = backup_config, attrs) do
    backup_config
    |> BackupConfig.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a backup_config.

  ## Examples

      iex> delete_backup_config(backup_config)
      {:ok, %BackupConfig{}}

      iex> delete_backup_config(backup_config)
      {:error, %Ecto.Changeset{}}

  """
  def delete_backup_config(%BackupConfig{} = backup_config) do
    Repo.delete(backup_config)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking backup_config changes.

  ## Examples

      iex> change_backup_config(backup_config)
      %Ecto.Changeset{data: %BackupConfig{}}

  """
  def change_backup_config(%BackupConfig{} = backup_config, attrs \\ %{}) do
    BackupConfig.changeset(backup_config, attrs)
  end
end
