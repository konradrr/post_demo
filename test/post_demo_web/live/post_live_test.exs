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

    test "showing Post with Comments correctly", ctx do
      %{conn: conn, post: post, comments: [comment]} = ctx

      {:ok, lv, _html} = live(conn, ~p"/")

      assert has_element?(lv, "h1", post.title)
      assert has_element?(lv, "p", post.body)

      assert has_element?(lv, "div", comment.author)
      assert has_element?(lv, "div", comment.body)
    end

    test "posting a comment to the post", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/")

      lv
      |> form("#comment_form")
      |> render_change(%{
        "comment" => %{author: "", body: "abc"}
      })

      assert has_element?(lv, ~s|div[phx-feedback-for="comment[author]"] p|, "can't be blank")

      lv
      |> form("#comment_form")
      |> render_change(%{
        "comment" => %{author: "Johnny", body: "abc"}
      })

      refute has_element?(lv, ~s(div[phx-feedback-for="comment[author]"] p), "can't be blank")

      html = lv |> form("#comment_form") |> render_submit()

      assert html =~ "Posted a comment!"
      assert has_element?(lv, "div", "Johnny")
      assert has_element?(lv, "div", "abc")
    end
  end
end
