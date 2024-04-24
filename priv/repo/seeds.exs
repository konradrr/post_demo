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

PostDemo.Repo.insert!(%PostDemo.Posts.Post{
  title: Faker.Lorem.sentence(),
  body: Faker.Lorem.paragraph()
})
