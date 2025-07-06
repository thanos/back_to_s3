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
end
