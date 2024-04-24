defmodule PostDemoWeb.PostLiveTest do
  use PostDemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import PostDemo.PostsFixtures

  defp create_post(_) do
    post = post_fixture()
    %{post: post}
  end

  describe "Showing post" do
    setup [:create_post]

    test "shows post correctly", %{conn: conn, post: post} do
      {:ok, lv, _html} = live(conn, ~p"/")

      assert has_element?(lv, "h1", post.title)
      assert has_element?(lv, "p", post.body)
    end
  end
end
