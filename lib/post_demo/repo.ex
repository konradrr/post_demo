defmodule PostDemo.Repo do
  use Ecto.Repo,
    otp_app: :post_demo,
    adapter: Ecto.Adapters.Postgres
end
