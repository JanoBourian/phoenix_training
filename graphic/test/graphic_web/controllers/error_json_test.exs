defmodule GraphicWeb.ErrorJSONTest do
  use GraphicWeb.ConnCase, async: true

  test "renders 404" do
    assert GraphicWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert GraphicWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
