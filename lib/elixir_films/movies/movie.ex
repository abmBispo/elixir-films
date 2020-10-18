defmodule ElixirFilms.Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :actors, :string
    field :status, :string
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
    |> cast(attrs, [:title, :genre, :released, :director, :actors, :poster, :status])
    |> validate_required([:title])
    |> unique_constraint(:title)
    |> put_status()
    |> validate_enum_status()
  end

  defp validate_enum_status(changeset) do
    validate_change(changeset, :status, fn :status, status ->
      case MovieStatus.valid_value?(status) do
        true -> []
        _ -> [status: "invalid value"]
      end
    end)
  end

  defp put_status(changeset) do
    case Map.get(changeset.data, :status) do
      nil -> put_change(changeset, :status, "not_synchronized")
      _ -> changeset
    end
  end
end
