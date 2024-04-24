defmodule PostDemo.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PostDemo.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: Faker.Lorem.paragraph(),
        title: Faker.Lorem.sentence()
      })
      |> PostDemo.Posts.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    attrs =
      if Map.has_key?(attrs, :post_id) do
        attrs
      else
        %{id: post_id} = post_fixture()
        Map.put(attrs, :post_id, post_id)
      end

    {:ok, comment} =
      attrs
      |> Enum.into(%{
        author: Faker.Internet.user_name(),
        body: Faker.Lorem.sentence(),
        posted_at: ~U[2024-04-23 07:47:00Z]
      })
      |> PostDemo.Posts.create_comment()

    comment
  end
end
