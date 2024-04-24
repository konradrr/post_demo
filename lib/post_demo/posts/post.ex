defmodule PostDemo.Posts.Post do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias PostDemo.Posts.Comment

  schema "posts" do
    field :title, :string
    field :body, :string

    has_many :comments, Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_length(:title, max: 255)
    |> validate_required([:title, :body])
  end
end
