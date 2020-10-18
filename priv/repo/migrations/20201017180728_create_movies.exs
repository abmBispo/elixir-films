defmodule ElixirFilms.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :title, :string, null: false
      add :genre, :string, null: false
      add :released, :date, null: false
      add :director, :string, null: false
      add :actors, :string, null: false
      add :poster, :string, null: false

      timestamps()
    end
    create index("movies", [:title], unique: true)
  end
end
