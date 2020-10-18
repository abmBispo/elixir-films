defmodule ElixirFilms.Movies.ImportMovieJob do
  require Logger
  use Que.Worker

  alias ElixirFilms.Movies
  alias ElixirFilms.Movies.Movie

  def perform(uri) do
    with omdb_response <- HTTPoison.get!(uri).body,
         parsed_data <- Jason.decode!(omdb_response),
         {:ok, movie_data} <- to_movie_data(parsed_data),
         {:ok, %Movie{} = movie} <- Movies.create_movie(movie_data),
         do: movie
  end

  defp to_movie_data(data) do
    if data["Error"] do
      {:error, :not_found}
    else
      {:ok, parsed_date} = Timex.parse(data["Released"], "%d %b %Y", :strftime)

      {:ok,
       %{
         actors: data["Actors"],
         director: data["Director"],
         genre: data["Genre"],
         poster: data["Poster"],
         released: NaiveDateTime.to_date(parsed_date),
         title: data["Title"]
       }}
    end
  end
end
