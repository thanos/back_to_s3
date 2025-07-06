defmodule BackToS3Web.SettingLiveTest do
  use BackToS3Web.ConnCase

  import Phoenix.LiveViewTest
  import BackToS3.ArchiveFixtures

  @create_attrs %{value: "some value", group: "some group", key: "some key"}
  @update_attrs %{value: "some updated value", group: "some updated group", key: "some updated key"}
  @invalid_attrs %{value: nil, group: nil, key: nil}
  defp create_setting(_) do
    setting = setting_fixture()

    %{setting: setting}
  end

  describe "Index" do
    setup [:create_setting]

    test "lists all settings", %{conn: conn, setting: setting} do
      {:ok, _index_live, html} = live(conn, ~p"/settings")

      assert html =~ "Listing Settings"
      assert html =~ setting.group
    end

    test "saves new setting", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/settings")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Setting")
               |> render_click()
               |> follow_redirect(conn, ~p"/settings/new")

      assert render(form_live) =~ "New Setting"

      assert form_live
             |> form("#setting-form", setting: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#setting-form", setting: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/settings")

      html = render(index_live)
      assert html =~ "Setting created successfully"
      assert html =~ "some group"
    end

    test "updates setting in listing", %{conn: conn, setting: setting} do
      {:ok, index_live, _html} = live(conn, ~p"/settings")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#settings-#{setting.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/settings/#{setting}/edit")

      assert render(form_live) =~ "Edit Setting"

      assert form_live
             |> form("#setting-form", setting: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#setting-form", setting: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/settings")

      html = render(index_live)
      assert html =~ "Setting updated successfully"
      assert html =~ "some updated group"
    end

    test "deletes setting in listing", %{conn: conn, setting: setting} do
      {:ok, index_live, _html} = live(conn, ~p"/settings")

      assert index_live |> element("#settings-#{setting.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#settings-#{setting.id}")
    end
  end

  describe "Show" do
    setup [:create_setting]

    test "displays setting", %{conn: conn, setting: setting} do
      {:ok, _show_live, html} = live(conn, ~p"/settings/#{setting}")

      assert html =~ "Show Setting"
      assert html =~ setting.group
    end

    test "updates setting and returns to show", %{conn: conn, setting: setting} do
      {:ok, show_live, _html} = live(conn, ~p"/settings/#{setting}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/settings/#{setting}/edit?return_to=show")

      assert render(form_live) =~ "Edit Setting"

      assert form_live
             |> form("#setting-form", setting: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#setting-form", setting: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/settings/#{setting}")

      html = render(show_live)
      assert html =~ "Setting updated successfully"
      assert html =~ "some updated group"
    end
  end
end
