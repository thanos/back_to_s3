defmodule BackToS3Web.BackupConfigLiveTest do
  use BackToS3Web.ConnCase

  import Phoenix.LiveViewTest
  import BackToS3.ArchivesFixtures

  @create_attrs %{label: "some label", source_path: "some source_path", destination_path: "some destination_path", s3_bucket: "some s3_bucket", is_active: true}
  @update_attrs %{label: "some updated label", source_path: "some updated source_path", destination_path: "some updated destination_path", s3_bucket: "some updated s3_bucket", is_active: false}
  @invalid_attrs %{label: nil, source_path: nil, destination_path: nil, s3_bucket: nil, is_active: false}
  defp create_backup_config(_) do
    backup_config = backup_config_fixture()

    %{backup_config: backup_config}
  end

  describe "Index" do
    setup [:create_backup_config]

    test "lists all backup_configs", %{conn: conn, backup_config: backup_config} do
      {:ok, _index_live, html} = live(conn, ~p"/backup_configs")

      assert html =~ "Listing Backup configs"
      assert html =~ backup_config.label
    end

    test "saves new backup_config", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/backup_configs")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Backup config")
               |> render_click()
               |> follow_redirect(conn, ~p"/backup_configs/new")

      assert render(form_live) =~ "New Backup config"

      assert form_live
             |> form("#backup_config-form", backup_config: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#backup_config-form", backup_config: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backup_configs")

      html = render(index_live)
      assert html =~ "Backup config created successfully"
      assert html =~ "some label"
    end

    test "updates backup_config in listing", %{conn: conn, backup_config: backup_config} do
      {:ok, index_live, _html} = live(conn, ~p"/backup_configs")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#backup_configs-#{backup_config.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/backup_configs/#{backup_config}/edit")

      assert render(form_live) =~ "Edit Backup config"

      assert form_live
             |> form("#backup_config-form", backup_config: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#backup_config-form", backup_config: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backup_configs")

      html = render(index_live)
      assert html =~ "Backup config updated successfully"
      assert html =~ "some updated label"
    end

    test "deletes backup_config in listing", %{conn: conn, backup_config: backup_config} do
      {:ok, index_live, _html} = live(conn, ~p"/backup_configs")

      assert index_live |> element("#backup_configs-#{backup_config.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#backup_configs-#{backup_config.id}")
    end
  end

  describe "Show" do
    setup [:create_backup_config]

    test "displays backup_config", %{conn: conn, backup_config: backup_config} do
      {:ok, _show_live, html} = live(conn, ~p"/backup_configs/#{backup_config}")

      assert html =~ "Show Backup config"
      assert html =~ backup_config.label
    end

    test "updates backup_config and returns to show", %{conn: conn, backup_config: backup_config} do
      {:ok, show_live, _html} = live(conn, ~p"/backup_configs/#{backup_config}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/backup_configs/#{backup_config}/edit?return_to=show")

      assert render(form_live) =~ "Edit Backup config"

      assert form_live
             |> form("#backup_config-form", backup_config: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#backup_config-form", backup_config: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backup_configs/#{backup_config}")

      html = render(show_live)
      assert html =~ "Backup config updated successfully"
      assert html =~ "some updated label"
    end
  end
end
