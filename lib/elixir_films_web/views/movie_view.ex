defmodule ElixirFilmsWeb.MovieView do
  use ElixirFilmsWeb, :view
  alias ElixirFilmsWeb.MovieView

  def render("index.json", %{movies: movies}) do
    %{data: render_many(movies, MovieView, "movie.json")}
  end

  def render("show.json", %{movie: movie}) do
    %{data: render_one(movie, MovieView, "movie.json")}
  end

  def render("movie.json", %{movie: movie}) do
    %{
      id: movie.id,
      title: movie.title,
      genre: movie.genre,
      released: movie.released || "N/A",
      director: movie.director,
      actors: movie.actors,
      poster: movie.poster,
      status: movie.status
    }
  end
end
