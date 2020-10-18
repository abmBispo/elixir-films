defmodule ElixirFilms.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    MovieStatus.create_type()
    create table(:movies) do
      add :title, :string, null: false
      add :parsed_title, :string, null: false
      add :status, MovieStatus.type(), null: false
      add :genre, :string, null: false, default: "N/A"
      add :released, :date
      add :director, :string, null: false, default: "N/A"
      add :actors, :string, null: false, default: "N/A"
      add :poster, :string, null: false, default: "N/A"

      timestamps()
    end

    create index("movies", [:title], unique: true)
    create index("movies", [:parsed_title], unique: true)
  end
end
