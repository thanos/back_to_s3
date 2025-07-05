defmodule BackToS3Web.BackupLiveTest do
  use BackToS3Web.ConnCase

  import Phoenix.LiveViewTest
  import BackToS3.ArchivesFixtures

  @create_attrs %{label: "some label", status: :"", path: "some path"}
  @update_attrs %{label: "some updated label", status: :"", path: "some updated path"}
  @invalid_attrs %{label: nil, status: nil, path: nil}
  defp create_backup(_) do
    backup = backup_fixture()

    %{backup: backup}
  end

  describe "Index" do
    setup [:create_backup]

    test "lists all backups", %{conn: conn, backup: backup} do
      {:ok, _index_live, html} = live(conn, ~p"/backups")

      assert html =~ "Listing Backups"
      assert html =~ backup.label
    end

    test "saves new backup", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/backups")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Backup")
               |> render_click()
               |> follow_redirect(conn, ~p"/backups/new")

      assert render(form_live) =~ "New Backup"

      assert form_live
             |> form("#backup-form", backup: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#backup-form", backup: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backups")

      html = render(index_live)
      assert html =~ "Backup created successfully"
      assert html =~ "some label"
    end

    test "updates backup in listing", %{conn: conn, backup: backup} do
      {:ok, index_live, _html} = live(conn, ~p"/backups")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#backups-#{backup.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/backups/#{backup}/edit")

      assert render(form_live) =~ "Edit Backup"

      assert form_live
             |> form("#backup-form", backup: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#backup-form", backup: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backups")

      html = render(index_live)
      assert html =~ "Backup updated successfully"
      assert html =~ "some updated label"
    end

    test "deletes backup in listing", %{conn: conn, backup: backup} do
      {:ok, index_live, _html} = live(conn, ~p"/backups")

      assert index_live |> element("#backups-#{backup.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#backups-#{backup.id}")
    end
  end

  describe "Show" do
    setup [:create_backup]

    test "displays backup", %{conn: conn, backup: backup} do
      {:ok, _show_live, html} = live(conn, ~p"/backups/#{backup}")

      assert html =~ "Show Backup"
      assert html =~ backup.label
    end

    test "updates backup and returns to show", %{conn: conn, backup: backup} do
      {:ok, show_live, _html} = live(conn, ~p"/backups/#{backup}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/backups/#{backup}/edit?return_to=show")

      assert render(form_live) =~ "Edit Backup"

      assert form_live
             |> form("#backup-form", backup: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#backup-form", backup: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backups/#{backup}")

      html = render(show_live)
      assert html =~ "Backup updated successfully"
      assert html =~ "some updated label"
    end
  end
end
