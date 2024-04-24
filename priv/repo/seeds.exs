# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PostDemo.Repo.insert!(%PostDemo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
if Mix.env() == :dev do
  post =
    PostDemo.Repo.insert!(%PostDemo.Posts.Post{
      title: Faker.Lorem.sentence(),
      body: Faker.Lorem.paragraph()
    })

  _comments =
    for _i <- 1..10 do
      PostDemo.Repo.insert!(%PostDemo.Posts.Comment{
        author: Faker.Internet.user_name(),
        body: 1..3 |> Enum.random() |> Faker.Lorem.sentences() |> Enum.join(" "),
        posted_at:
          DateTime.utc_now()
          |> DateTime.add(Enum.random(-10_000..-10), :minute)
          |> DateTime.truncate(:second),
        post_id: post.id
      })
    end
end
