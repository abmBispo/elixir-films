defmodule ElixirFilms.Repo do
  use Ecto.Repo,
    otp_app: :elixir_films,
    adapter: Ecto.Adapters.Postgres
end
