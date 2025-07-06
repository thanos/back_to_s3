defmodule BackToS3Web.BackupDefLiveTest do
  use BackToS3Web.ConnCase

  import Phoenix.LiveViewTest
  import BackToS3.ArchiveFixtures

  @create_attrs %{label: "some label", status: :running, on: true, source_path: "some source_path", s3_destination: "some s3_destination", s3_bucket: "some s3_bucket", cron: "some cron", last_run: "2025-07-05T20:53:00Z", when_completed: "2025-07-05T20:53:00Z"}
  @update_attrs %{label: "some updated label", status: :succeeded, on: false, source_path: "some updated source_path", s3_destination: "some updated s3_destination", s3_bucket: "some updated s3_bucket", cron: "some updated cron", last_run: "2025-07-06T20:53:00Z", when_completed: "2025-07-06T20:53:00Z"}
  @invalid_attrs %{label: nil, status: nil, on: false, source_path: nil, s3_destination: nil, s3_bucket: nil, cron: nil, last_run: nil, when_completed: nil}
  defp create_backup_def(_) do
    backup_def = backup_def_fixture()

    %{backup_def: backup_def}
  end

  describe "Index" do
    setup [:create_backup_def]

    test "lists all backup_defs", %{conn: conn, backup_def: backup_def} do
      {:ok, _index_live, html} = live(conn, ~p"/backup_defs")

      assert html =~ "Listing Backup defs"
      assert html =~ backup_def.label
    end

    test "saves new backup_def", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/backup_defs")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Backup def")
               |> render_click()
               |> follow_redirect(conn, ~p"/backup_defs/new")

      assert render(form_live) =~ "New Backup def"

      assert form_live
             |> form("#backup_def-form", backup_def: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#backup_def-form", backup_def: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backup_defs")

      html = render(index_live)
      assert html =~ "Backup def created successfully"
      assert html =~ "some label"
    end

    test "updates backup_def in listing", %{conn: conn, backup_def: backup_def} do
      {:ok, index_live, _html} = live(conn, ~p"/backup_defs")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#backup_defs-#{backup_def.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/backup_defs/#{backup_def}/edit")

      assert render(form_live) =~ "Edit Backup def"

      assert form_live
             |> form("#backup_def-form", backup_def: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#backup_def-form", backup_def: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backup_defs")

      html = render(index_live)
      assert html =~ "Backup def updated successfully"
      assert html =~ "some updated label"
    end

    test "deletes backup_def in listing", %{conn: conn, backup_def: backup_def} do
      {:ok, index_live, _html} = live(conn, ~p"/backup_defs")

      assert index_live |> element("#backup_defs-#{backup_def.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#backup_defs-#{backup_def.id}")
    end
  end

  describe "Show" do
    setup [:create_backup_def]

    test "displays backup_def", %{conn: conn, backup_def: backup_def} do
      {:ok, _show_live, html} = live(conn, ~p"/backup_defs/#{backup_def}")

      assert html =~ "Show Backup def"
      assert html =~ backup_def.label
    end

    test "updates backup_def and returns to show", %{conn: conn, backup_def: backup_def} do
      {:ok, show_live, _html} = live(conn, ~p"/backup_defs/#{backup_def}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/backup_defs/#{backup_def}/edit?return_to=show")

      assert render(form_live) =~ "Edit Backup def"

      assert form_live
             |> form("#backup_def-form", backup_def: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#backup_def-form", backup_def: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/backup_defs/#{backup_def}")

      html = render(show_live)
      assert html =~ "Backup def updated successfully"
      assert html =~ "some updated label"
    end
  end
end
