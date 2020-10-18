defmodule ElixirFilmsWeb.MovieControllerTest do
  use ElixirFilmsWeb.ConnCase

  alias ElixirFilms.Movies

  @create_attrs %{
    actors: "some actors",
    director: "some director",
    genre: "some genre",
    poster: "some poster",
    released: ~D[2010-04-17],
    title: "some title"
  }

  @import_json [
    %{
      title: "V for Vendetta"
    },
    %{
      title: "Captain Marvel"
    },
    %{
      title: "Frozen"
    },
    %{
      title: "Click"
    },
    %{
      title: "Airplane!"
    },
    %{
      title: "Doctor Strange"
    }
  ]

  def fixture(:movie) do
    {:ok, movie} = Movies.create_movie(@create_attrs)
    movie
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all movies", %{conn: conn} do
      create_movie()
      conn = get(conn, Routes.movie_path(conn, :index))

      data =
        json_response(conn, 200)["data"]
        |> List.first()

      assert data["actors"] == "some actors"
      assert data["title"] == "some title"
    end
  end

  describe "import" do
    test "send list of titles to be imported", %{conn: conn} do
      conn = post(conn, Routes.movie_path(conn, :omdb_import), _json: @import_json)
      assert response(conn, 204) == ""
      :timer.sleep(500)

      conn = get(conn, Routes.movie_path(conn, :index))

      data =
        json_response(conn, 200)["data"]
        |> List.first()

      assert data["title"] == "V for Vendetta"
      assert data["status"] == "fetched"
    end
  end

  defp create_movie() do
    movie = fixture(:movie)
    %{movie: movie}
  end
end
