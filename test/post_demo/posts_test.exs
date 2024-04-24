defmodule PostDemo.PostsTest do
  use PostDemo.DataCase

  import PostDemo.PostsFixtures

  alias PostDemo.Posts
  alias PostDemo.Posts.Comment
  alias PostDemo.Posts.Post

  describe "posts" do
    @invalid_attrs %{title: nil, body: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.title == "some title"
      assert post.body == "some body"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.title == "some updated title"
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end

  describe "comments" do
    @invalid_attrs %{author: nil, body: nil, posted_at: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Posts.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Posts.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      post = post_fixture()
      valid_attrs = %{post_id: post.id, author: "some author", body: "some body", posted_at: ~U[2024-04-23 07:47:00Z]}

      assert {:ok, %Comment{} = comment} = Posts.create_comment(valid_attrs)

      assert comment.author == "some author"
      assert comment.body == "some body"
      assert comment.posted_at == ~U[2024-04-23 07:47:00Z]
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_comment(@invalid_attrs)
    end

    test "create_comment/1 with too long author or body returns error changeset" do
      attrs = %{author: String.duplicate("a", 256), body: String.duplicate("a", 751)}
      assert {:error, %Ecto.Changeset{errors: errors}} = Posts.create_comment(attrs)

      assert elem(errors[:author], 0) == "should be at most %{count} character(s)"
      assert elem(errors[:body], 0) == "should be at most %{count} character(s)"
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{author: "some updated author", body: "some updated body", posted_at: ~U[2024-04-24 07:47:00Z]}

      assert {:ok, %Comment{} = comment} = Posts.update_comment(comment, update_attrs)
      assert comment.author == "some updated author"
      assert comment.body == "some updated body"
      assert comment.posted_at == ~U[2024-04-24 07:47:00Z]
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_comment(comment, @invalid_attrs)
      assert comment == Posts.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Posts.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Posts.change_comment(comment)
    end

    test "get_comments_by_post/1 returns comments for a given Post" do
      post = post_fixture()
      other_post = post_fixture()
      comment = comment_fixture(%{post_id: post.id})
      _other_comment = comment_fixture(%{post_id: other_post.id})

      assert [db_comment] = Posts.get_comments_by_post(post)

      assert db_comment.post_id == post.id
      assert db_comment.id == comment.id
    end

    test "get_comments_by_post/1 returns comments for a given Post's id" do
      post = post_fixture()
      other_post = post_fixture()
      comment = comment_fixture(%{post_id: post.id})
      _other_comment = comment_fixture(%{post_id: other_post.id})

      assert [db_comment] = Posts.get_comments_by_post(post.id)

      assert db_comment.post_id == post.id
      assert db_comment.id == comment.id
    end
  end
end
