defmodule BackToS3Web.PageControllerTest do
  use BackToS3Web.ConnCase

  test "GET / no aws setup", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 302) =~ "<html><body>You are being <a href=\"/aws-setup/new\">redirected</a>.</body></html>"
  end

  test "GET /", %{conn: conn} do

    BackToS3.ArchiveFixtures.setting_fixture(%{ group: "setup", key: "AWS_SETUP", value: Jason.encode!(%{aws_access_key_id: "123", aws_secret_access_key: "456"}) })
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from your drives to S3."
  end
end
