defmodule ElixirFilmsWeb.MovieController do
  use ElixirFilmsWeb, :controller

  alias ElixirFilms.Movies
  alias ElixirFilms.Movies.Movie

  action_fallback ElixirFilmsWeb.FallbackController

  def index(conn, _params) do
    movies = Movies.list_movies()
    render(conn, "index.json", movies: movies)
  end

  def show(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    render(conn, "show.json", movie: movie)
  end

  def omdb_import(conn, params) do
    params
    |> Map.get("_json")
    |> Movies.import()

    send_resp(conn, :no_content, "")
  end
end