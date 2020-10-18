defmodule ElixirFilms.MoviesTest do
  use ElixirFilms.DataCase

  alias ElixirFilms.Movies

  describe "movies" do
    alias ElixirFilms.Movies.Movie

    @valid_attrs %{actors: "some actors", director: "some director", genre: "some genre", poster: "some poster", released: ~D[2010-04-17], title: "some title"}
    @update_attrs %{actors: "some updated actors", director: "some updated director", genre: "some updated genre", poster: "some updated poster", released: ~D[2011-05-18], title: "some updated title"}
    @invalid_attrs %{actors: nil, director: nil, genre: nil, poster: nil, released: nil, title: nil}

    def movie_fixture(attrs \\ %{}) do
      {:ok, movie} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Movies.create_movie()

      movie
    end

    test "list_movies/0 returns all movies" do
      movie = movie_fixture()
      assert Movies.list_movies(%{}).entries == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Movies.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      assert {:ok, %Movie{} = movie} = Movies.create_movie(@valid_attrs)
      assert movie.actors == "some actors"
      assert movie.director == "some director"
      assert movie.genre == "some genre"
      assert movie.poster == "some poster"
      assert movie.released == ~D[2010-04-17]
      assert movie.title == "some title"
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movies.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{} = movie} = Movies.update_movie(movie, @update_attrs)
      assert movie.actors == "some updated actors"
      assert movie.director == "some updated director"
      assert movie.genre == "some updated genre"
      assert movie.poster == "some updated poster"
      assert movie.released == ~D[2011-05-18]
      assert movie.title == "some updated title"
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Movies.update_movie(movie, @invalid_attrs)
      assert movie == Movies.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Movies.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Movies.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Movies.change_movie(movie)
    end
  end
end
