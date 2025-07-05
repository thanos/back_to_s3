defmodule BackToS3Web.FileLiveTest do
  use BackToS3Web.ConnCase

  import Phoenix.LiveViewTest
  import BackToS3.ArchivesFixtures

  @create_attrs %{error: "some error", md5: "some md5", size: 42, status: :pending, mtime: "2025-07-03T18:11:00", original_file: "some original_file", s3_key: "some s3_key", s3_bucket: "some s3_bucket", s3_etag: "some s3_etag", job_id: 42}
  @update_attrs %{error: "some updated error", md5: "some updated md5", size: 43, status: :in_process, mtime: "2025-07-04T18:11:00", original_file: "some updated original_file", s3_key: "some updated s3_key", s3_bucket: "some updated s3_bucket", s3_etag: "some updated s3_etag", job_id: 43}
  @invalid_attrs %{error: nil, md5: nil, size: nil, status: nil, mtime: nil, original_file: nil, s3_key: nil, s3_bucket: nil, s3_etag: nil, job_id: nil}
  defp create_file(_) do
    file = file_fixture()

    %{file: file}
  end

  describe "Index" do
    setup [:create_file]

    test "lists all files", %{conn: conn, file: file} do
      {:ok, _index_live, html} = live(conn, ~p"/files")

      assert html =~ "Listing Files"
      assert html =~ file.original_file
    end

    test "saves new file", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New File")
               |> render_click()
               |> follow_redirect(conn, ~p"/files/new")

      assert render(form_live) =~ "New File"

      assert form_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#file-form", file: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/files")

      html = render(index_live)
      assert html =~ "File created successfully"
      assert html =~ "some original_file"
    end

    test "updates file in listing", %{conn: conn, file: file} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#files-#{file.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/files/#{file}/edit")

      assert render(form_live) =~ "Edit File"

      assert form_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#file-form", file: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/files")

      html = render(index_live)
      assert html =~ "File updated successfully"
      assert html =~ "some updated original_file"
    end

    test "deletes file in listing", %{conn: conn, file: file} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert index_live |> element("#files-#{file.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#files-#{file.id}")
    end
  end

  describe "Show" do
    setup [:create_file]

    test "displays file", %{conn: conn, file: file} do
      {:ok, _show_live, html} = live(conn, ~p"/files/#{file}")

      assert html =~ "Show File"
      assert html =~ file.original_file
    end

    test "updates file and returns to show", %{conn: conn, file: file} do
      {:ok, show_live, _html} = live(conn, ~p"/files/#{file}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/files/#{file}/edit?return_to=show")

      assert render(form_live) =~ "Edit File"

      assert form_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#file-form", file: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/files/#{file}")

      html = render(show_live)
      assert html =~ "File updated successfully"
      assert html =~ "some updated original_file"
    end
  end
end
