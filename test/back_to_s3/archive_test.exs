defmodule BackToS3.ArchiveTest do
  use BackToS3.DataCase

  alias BackToS3.Archive

  describe "settings" do
    alias BackToS3.Archive.Setting

    import BackToS3.ArchiveFixtures

    @invalid_attrs %{value: nil, group: nil, key: nil}

    test "list_settings/0 returns all settings" do
      setting = setting_fixture()
      assert Archive.list_settings() == [setting]
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Archive.get_setting!(setting.id) == setting
    end

    test "create_setting/1 with valid data creates a setting" do
      valid_attrs = %{value: "some value", group: "some group", key: "some key"}

      assert {:ok, %Setting{} = setting} = Archive.create_setting(valid_attrs)
      assert setting.value == "some value"
      assert setting.group == "some group"
      assert setting.key == "some key"
    end

    test "create_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Archive.create_setting(@invalid_attrs)
    end

    test "update_setting/2 with valid data updates the setting" do
      setting = setting_fixture()
      update_attrs = %{value: "some updated value", group: "some updated group", key: "some updated key"}

      assert {:ok, %Setting{} = setting} = Archive.update_setting(setting, update_attrs)
      assert setting.value == "some updated value"
      assert setting.group == "some updated group"
      assert setting.key == "some updated key"
    end

    test "update_setting/2 with invalid data returns error changeset" do
      setting = setting_fixture()
      assert {:error, %Ecto.Changeset{}} = Archive.update_setting(setting, @invalid_attrs)
      assert setting == Archive.get_setting!(setting.id)
    end

    test "delete_setting/1 deletes the setting" do
      setting = setting_fixture()
      assert {:ok, %Setting{}} = Archive.delete_setting(setting)
      assert_raise Ecto.NoResultsError, fn -> Archive.get_setting!(setting.id) end
    end

    test "change_setting/1 returns a setting changeset" do
      setting = setting_fixture()
      assert %Ecto.Changeset{} = Archive.change_setting(setting)
    end
  end

  describe "backup_defs" do
    alias BackToS3.Archive.BackupDef

    import BackToS3.ArchiveFixtures

    @invalid_attrs %{label: nil, status: nil, on: nil, source_path: nil, s3_destination: nil, s3_bucket: nil, cron: nil, last_run: nil, when_completed: nil}

    test "list_backup_defs/0 returns all backup_defs" do
      backup_def = backup_def_fixture()
      assert Archive.list_backup_defs() == [backup_def]
    end

    test "get_backup_def!/1 returns the backup_def with given id" do
      backup_def = backup_def_fixture()
      assert Archive.get_backup_def!(backup_def.id) == backup_def
    end

    test "create_backup_def/1 with valid data creates a backup_def" do
      valid_attrs = %{label: "some label", status: :running, on: true, source_path: "some source_path", s3_destination: "some s3_destination", s3_bucket: "some s3_bucket", cron: "some cron", last_run: ~U[2025-07-05 20:53:00Z], when_completed: ~U[2025-07-05 20:53:00Z]}

      assert {:ok, %BackupDef{} = backup_def} = Archive.create_backup_def(valid_attrs)
      assert backup_def.label == "some label"
      assert backup_def.status == :running
      assert backup_def.on == true
      assert backup_def.source_path == "some source_path"
      assert backup_def.s3_destination == "some s3_destination"
      assert backup_def.s3_bucket == "some s3_bucket"
      assert backup_def.cron == "some cron"
      assert backup_def.last_run == ~U[2025-07-05 20:53:00Z]
      assert backup_def.when_completed == ~U[2025-07-05 20:53:00Z]
    end

    test "create_backup_def/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Archive.create_backup_def(@invalid_attrs)
    end

    test "update_backup_def/2 with valid data updates the backup_def" do
      backup_def = backup_def_fixture()
      update_attrs = %{label: "some updated label", status: :succeeded, on: false, source_path: "some updated source_path", s3_destination: "some updated s3_destination", s3_bucket: "some updated s3_bucket", cron: "some updated cron", last_run: ~U[2025-07-06 20:53:00Z], when_completed: ~U[2025-07-06 20:53:00Z]}

      assert {:ok, %BackupDef{} = backup_def} = Archive.update_backup_def(backup_def, update_attrs)
      assert backup_def.label == "some updated label"
      assert backup_def.status == :succeeded
      assert backup_def.on == false
      assert backup_def.source_path == "some updated source_path"
      assert backup_def.s3_destination == "some updated s3_destination"
      assert backup_def.s3_bucket == "some updated s3_bucket"
      assert backup_def.cron == "some updated cron"
      assert backup_def.last_run == ~U[2025-07-06 20:53:00Z]
      assert backup_def.when_completed == ~U[2025-07-06 20:53:00Z]
    end

    test "update_backup_def/2 with invalid data returns error changeset" do
      backup_def = backup_def_fixture()
      assert {:error, %Ecto.Changeset{}} = Archive.update_backup_def(backup_def, @invalid_attrs)
      assert backup_def == Archive.get_backup_def!(backup_def.id)
    end

    test "delete_backup_def/1 deletes the backup_def" do
      backup_def = backup_def_fixture()
      assert {:ok, %BackupDef{}} = Archive.delete_backup_def(backup_def)
      assert_raise Ecto.NoResultsError, fn -> Archive.get_backup_def!(backup_def.id) end
    end

    test "change_backup_def/1 returns a backup_def changeset" do
      backup_def = backup_def_fixture()
      assert %Ecto.Changeset{} = Archive.change_backup_def(backup_def)
    end
  end
end
