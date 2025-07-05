defmodule BackToS3.ArchivesTest do
  use BackToS3.DataCase

  alias BackToS3.Archives

  describe "backups" do
    alias BackToS3.Archives.Backup

    import BackToS3.ArchivesFixtures

    @invalid_attrs %{label: nil, status: nil, path: nil}

    test "list_backups/0 returns all backups" do
      backup = backup_fixture()
      assert Archives.list_backups() == [backup]
    end

    test "get_backup!/1 returns the backup with given id" do
      backup = backup_fixture()
      assert Archives.get_backup!(backup.id) == backup
    end

    test "create_backup/1 with valid data creates a backup" do
      valid_attrs = %{label: "some label", status: :"", path: "some path"}

      assert {:ok, %Backup{} = backup} = Archives.create_backup(valid_attrs)
      assert backup.label == "some label"
      assert backup.status == :""
      assert backup.path == "some path"
    end

    test "create_backup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Archives.create_backup(@invalid_attrs)
    end

    test "update_backup/2 with valid data updates the backup" do
      backup = backup_fixture()
      update_attrs = %{label: "some updated label", status: :"", path: "some updated path"}

      assert {:ok, %Backup{} = backup} = Archives.update_backup(backup, update_attrs)
      assert backup.label == "some updated label"
      assert backup.status == :""
      assert backup.path == "some updated path"
    end

    test "update_backup/2 with invalid data returns error changeset" do
      backup = backup_fixture()
      assert {:error, %Ecto.Changeset{}} = Archives.update_backup(backup, @invalid_attrs)
      assert backup == Archives.get_backup!(backup.id)
    end

    test "delete_backup/1 deletes the backup" do
      backup = backup_fixture()
      assert {:ok, %Backup{}} = Archives.delete_backup(backup)
      assert_raise Ecto.NoResultsError, fn -> Archives.get_backup!(backup.id) end
    end

    test "change_backup/1 returns a backup changeset" do
      backup = backup_fixture()
      assert %Ecto.Changeset{} = Archives.change_backup(backup)
    end
  end

  describe "files" do
    alias BackToS3.Archives.File

    import BackToS3.ArchivesFixtures

    @invalid_attrs %{error: nil, md5: nil, size: nil, status: nil, mtime: nil, original_file: nil, s3_key: nil, s3_bucket: nil, s3_etag: nil, job_id: nil}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Archives.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Archives.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{error: "some error", md5: "some md5", size: 42, status: :pending, mtime: ~N[2025-07-03 18:09:00], original_file: "some original_file", s3_key: "some s3_key", s3_bucket: "some s3_bucket", s3_etag: "some s3_etag", job_id: 42}

      assert {:ok, %File{} = file} = Archives.create_file(valid_attrs)
      assert file.error == "some error"
      assert file.md5 == "some md5"
      assert file.size == 42
      assert file.status == :pending
      assert file.mtime == ~N[2025-07-03 18:09:00]
      assert file.original_file == "some original_file"
      assert file.s3_key == "some s3_key"
      assert file.s3_bucket == "some s3_bucket"
      assert file.s3_etag == "some s3_etag"
      assert file.job_id == 42
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Archives.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      update_attrs = %{error: "some updated error", md5: "some updated md5", size: 43, status: :in_process, mtime: ~N[2025-07-04 18:09:00], original_file: "some updated original_file", s3_key: "some updated s3_key", s3_bucket: "some updated s3_bucket", s3_etag: "some updated s3_etag", job_id: 43}

      assert {:ok, %File{} = file} = Archives.update_file(file, update_attrs)
      assert file.error == "some updated error"
      assert file.md5 == "some updated md5"
      assert file.size == 43
      assert file.status == :in_process
      assert file.mtime == ~N[2025-07-04 18:09:00]
      assert file.original_file == "some updated original_file"
      assert file.s3_key == "some updated s3_key"
      assert file.s3_bucket == "some updated s3_bucket"
      assert file.s3_etag == "some updated s3_etag"
      assert file.job_id == 43
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Archives.update_file(file, @invalid_attrs)
      assert file == Archives.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Archives.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Archives.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Archives.change_file(file)
    end
  end

  describe "files" do
    alias BackToS3.Archives.File

    import BackToS3.ArchivesFixtures

    @invalid_attrs %{error: nil, md5: nil, size: nil, status: nil, mtime: nil, original_file: nil, s3_key: nil, s3_bucket: nil, s3_etag: nil, job_id: nil}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Archives.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Archives.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{error: "some error", md5: "some md5", size: 42, status: :pending, mtime: ~N[2025-07-03 18:11:00], original_file: "some original_file", s3_key: "some s3_key", s3_bucket: "some s3_bucket", s3_etag: "some s3_etag", job_id: 42}

      assert {:ok, %File{} = file} = Archives.create_file(valid_attrs)
      assert file.error == "some error"
      assert file.md5 == "some md5"
      assert file.size == 42
      assert file.status == :pending
      assert file.mtime == ~N[2025-07-03 18:11:00]
      assert file.original_file == "some original_file"
      assert file.s3_key == "some s3_key"
      assert file.s3_bucket == "some s3_bucket"
      assert file.s3_etag == "some s3_etag"
      assert file.job_id == 42
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Archives.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      update_attrs = %{error: "some updated error", md5: "some updated md5", size: 43, status: :in_process, mtime: ~N[2025-07-04 18:11:00], original_file: "some updated original_file", s3_key: "some updated s3_key", s3_bucket: "some updated s3_bucket", s3_etag: "some updated s3_etag", job_id: 43}

      assert {:ok, %File{} = file} = Archives.update_file(file, update_attrs)
      assert file.error == "some updated error"
      assert file.md5 == "some updated md5"
      assert file.size == 43
      assert file.status == :in_process
      assert file.mtime == ~N[2025-07-04 18:11:00]
      assert file.original_file == "some updated original_file"
      assert file.s3_key == "some updated s3_key"
      assert file.s3_bucket == "some updated s3_bucket"
      assert file.s3_etag == "some updated s3_etag"
      assert file.job_id == 43
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Archives.update_file(file, @invalid_attrs)
      assert file == Archives.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Archives.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Archives.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Archives.change_file(file)
    end
  end

  describe "backup_configs" do
    alias BackToS3.Archives.BackupConfig

    import BackToS3.ArchivesFixtures

    @invalid_attrs %{label: nil, source_path: nil, destination_path: nil, s3_bucket: nil, is_active: nil}

    test "list_backup_configs/0 returns all backup_configs" do
      backup_config = backup_config_fixture()
      assert Archives.list_backup_configs() == [backup_config]
    end

    test "get_backup_config!/1 returns the backup_config with given id" do
      backup_config = backup_config_fixture()
      assert Archives.get_backup_config!(backup_config.id) == backup_config
    end

    test "create_backup_config/1 with valid data creates a backup_config" do
      valid_attrs = %{label: "some label", source_path: "some source_path", destination_path: "some destination_path", s3_bucket: "some s3_bucket", is_active: true}

      assert {:ok, %BackupConfig{} = backup_config} = Archives.create_backup_config(valid_attrs)
      assert backup_config.label == "some label"
      assert backup_config.source_path == "some source_path"
      assert backup_config.destination_path == "some destination_path"
      assert backup_config.s3_bucket == "some s3_bucket"
      assert backup_config.is_active == true
    end

    test "create_backup_config/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Archives.create_backup_config(@invalid_attrs)
    end

    test "update_backup_config/2 with valid data updates the backup_config" do
      backup_config = backup_config_fixture()
      update_attrs = %{label: "some updated label", source_path: "some updated source_path", destination_path: "some updated destination_path", s3_bucket: "some updated s3_bucket", is_active: false}

      assert {:ok, %BackupConfig{} = backup_config} = Archives.update_backup_config(backup_config, update_attrs)
      assert backup_config.label == "some updated label"
      assert backup_config.source_path == "some updated source_path"
      assert backup_config.destination_path == "some updated destination_path"
      assert backup_config.s3_bucket == "some updated s3_bucket"
      assert backup_config.is_active == false
    end

    test "update_backup_config/2 with invalid data returns error changeset" do
      backup_config = backup_config_fixture()
      assert {:error, %Ecto.Changeset{}} = Archives.update_backup_config(backup_config, @invalid_attrs)
      assert backup_config == Archives.get_backup_config!(backup_config.id)
    end

    test "delete_backup_config/1 deletes the backup_config" do
      backup_config = backup_config_fixture()
      assert {:ok, %BackupConfig{}} = Archives.delete_backup_config(backup_config)
      assert_raise Ecto.NoResultsError, fn -> Archives.get_backup_config!(backup_config.id) end
    end

    test "change_backup_config/1 returns a backup_config changeset" do
      backup_config = backup_config_fixture()
      assert %Ecto.Changeset{} = Archives.change_backup_config(backup_config)
    end
  end
end
