defmodule ElixirFilms.Movies.ImportMovieJob do
  require Logger
  use Que.Worker, concurrency: 8

  alias ElixirFilms.Movies
  alias ElixirFilms.Movies.Movie

  @omdb_url "http://www.omdbapi.com/?i=tt3896198&apikey=def1de67&t="

  def perform(movie_title) do
    movie =
      case Movies.create_movie(%{title: movie_title, status: "syncing"}) do
        {:ok, movie} ->
          movie

        {:error, %Ecto.Changeset{changes: %{parsed_title: parsed_title}}} ->
          Movies.get_movie!(parsed_title: parsed_title)
      end

    uri = @omdb_url <> movie.parsed_title

    with omdb_response <- HTTPoison.get!(uri).body,
         parsed_data <- Jason.decode!(omdb_response),
         {:ok, movie_data} <- to_movie_data(parsed_data),
         {:ok, %Movie{} = movie} <- Movies.update_movie(movie, movie_data) do
      movie
    else
      _ -> Movies.update_movie(movie, %{status: "failed"})
    end
  end

  defp to_movie_data(data) do
    if data["Error"] do
      {:error, :not_found}
    else
      parsed_date =
        if data["Released"] != "N/A" do
          {:ok, parsed_date} = Timex.parse(data["Released"], "%d %b %Y", :strftime)
          NaiveDateTime.to_date(parsed_date)
        else
          nil
        end

      {:ok,
       %{
         actors: data["Actors"],
         director: data["Director"],
         genre: data["Genre"],
         poster: data["Poster"],
         released: parsed_date,
         title: data["Title"],
         status: "fetched"
       }}
    end
  end
end
