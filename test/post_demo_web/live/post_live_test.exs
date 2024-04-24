defmodule PostDemoWeb.PostLiveTest do
  use PostDemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import PostDemo.PostsFixtures

  defp create_post(_) do
    post = post_fixture()
    comments = [comment_fixture(%{post_id: post.id})]
    %{post: post, comments: comments}
  end

  describe "Showing post" do
    setup [:create_post]

    test "shows Post with Comments correctly", ctx do
      %{conn: conn, post: post, comments: [comment]} = ctx

      {:ok, lv, _html} = live(conn, ~p"/")

      assert has_element?(lv, "h1", post.title)
      assert has_element?(lv, "p", post.body)

      assert has_element?(lv, "div", comment.author)
      assert has_element?(lv, "div", comment.body)
    end
  end
end
