defmodule PostDemo.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text, null: false
      add :author, :string, null: false
      add :posted_at, :utc_datetime, null: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:post_id])
    create index(:comments, [:posted_at])
  end
end
