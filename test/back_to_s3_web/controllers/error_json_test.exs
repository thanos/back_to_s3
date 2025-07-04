defmodule BackToS3Web.ErrorJSONTest do
  use BackToS3Web.ConnCase, async: true

  test "renders 404" do
    assert BackToS3Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert BackToS3Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
