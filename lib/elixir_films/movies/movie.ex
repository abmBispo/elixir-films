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
    field :parsed_title, :string

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :genre, :released, :director, :actors, :poster, :status])
    |> put_parsed_title()
    |> put_status()
    |> validate_enum_status()
    |> validate_required([:title, :parsed_title])
    |> unique_constraint(:title)
    |> unique_constraint(:parsed_title)
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
    status = Map.get(changeset.data, :status) || Map.get(changeset.changes, :status)

    case status do
      nil -> put_change(changeset, :status, "not_synchronized")
      _ -> changeset
    end
  end

  defp put_parsed_title(changeset) do
    title = Map.get(changeset.data, :title) || Map.get(changeset.changes, :title)

    case title do
      nil ->
        changeset

      _ ->
        parsed_title =
          String.downcase(title)
          |> String.replace(" ", "+")

        put_change(changeset, :parsed_title, parsed_title)
    end
  end
end
