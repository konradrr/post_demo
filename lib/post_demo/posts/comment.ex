defmodule PostDemo.Posts.Comment do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias PostDemo.Posts.Post

  @cast_attrs ~w(author body posted_at post_id)a
  @required_attrs ~w(author body posted_at)a

  schema "comments" do
    field :author, :string
    field :body, :string
    field :posted_at, :utc_datetime

    belongs_to :post, Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @cast_attrs)
    |> validate_length(:author, max: 255)
    |> validate_length(:body, max: 750)
    |> validate_required(@required_attrs)
  end
end
