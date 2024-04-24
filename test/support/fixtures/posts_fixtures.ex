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
end
