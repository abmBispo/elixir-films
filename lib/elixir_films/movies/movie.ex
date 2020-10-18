defmodule ElixirFilms.Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :actors, :string
    field :director, :string
    field :genre, :string
    field :poster, :string
    field :released, :date
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :genre, :released, :director, :actors, :poster])
    |> validate_required([:title, :genre, :released, :director, :actors, :poster])
    |> unique_constraint(:title)
  end
end
