defmodule ElixirFilmsWeb.MovieControllerTest do
  use ElixirFilmsWeb.ConnCase

  alias ElixirFilms.Movies
  alias ElixirFilms.Movies.Movie

  @create_attrs %{
    actors: "some actors",
    director: "some director",
    genre: "some genre",
    poster: "some poster",
    released: ~D[2010-04-17],
    title: "some title"
  }
  @update_attrs %{
    actors: "some updated actors",
    director: "some updated director",
    genre: "some updated genre",
    poster: "some updated poster",
    released: ~D[2011-05-18],
    title: "some updated title"
  }
  @invalid_attrs %{actors: nil, director: nil, genre: nil, poster: nil, released: nil, title: nil}

  def fixture(:movie) do
    {:ok, movie} = Movies.create_movie(@create_attrs)
    movie
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all movies", %{conn: conn} do
      conn = get(conn, Routes.movie_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create movie" do
    test "renders movie when data is valid", %{conn: conn} do
      conn = post(conn, Routes.movie_path(conn, :create), movie: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.movie_path(conn, :show, id))

      assert %{
               "id" => id,
               "actors" => "some actors",
               "director" => "some director",
               "genre" => "some genre",
               "poster" => "some poster",
               "released" => "2010-04-17",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.movie_path(conn, :create), movie: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update movie" do
    setup [:create_movie]

    test "renders movie when data is valid", %{conn: conn, movie: %Movie{id: id} = movie} do
      conn = put(conn, Routes.movie_path(conn, :update, movie), movie: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.movie_path(conn, :show, id))

      assert %{
               "id" => id,
               "actors" => "some updated actors",
               "director" => "some updated director",
               "genre" => "some updated genre",
               "poster" => "some updated poster",
               "released" => "2011-05-18",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, movie: movie} do
      conn = put(conn, Routes.movie_path(conn, :update, movie), movie: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete movie" do
    setup [:create_movie]

    test "deletes chosen movie", %{conn: conn, movie: movie} do
      conn = delete(conn, Routes.movie_path(conn, :delete, movie))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.movie_path(conn, :show, movie))
      end
    end
  end

  defp create_movie(_) do
    movie = fixture(:movie)
    %{movie: movie}
  end
end
