# Elixir Films

## Running it
### Requirements
You'll have to get installed in your machine the following softwares versions for better testing experience:
- Elixir 1.10.2 (compiled with Erlang/OTP 22)
- Postgres 9.6
### Commands
Elixir code setup:
```
$ git clone git@github.com:abmBispo/elixir-films.git
$ cd elixir-films
$ mix deps.get
```

Postgres database (running in docker):
```
docker run --name postgres-database -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres
```

In order to run it with no docker, you'll also have to modify the `config/dev.exs` file, configuring it to access local (`127.0.0.1`) database:
```ex
config :elixir_films, ElixirFilms.Repo,
  username: "postgres",
  password: "postgres",
  database: "elixir_films_dev",
  hostname: "127.0.0.1",
  pool: 10
```

Now migrate the models with:
```
$ mix ecto.migrate
```

And have fun:
```
$ mix phx.server
```

### Alternative: `docker-compose`
Or you can alternatively get it all via `docker-compose` just by installing it (my version was **1.21.2, build a133471**) and enter:
```
$ docker-compose build
$ docker-compose run web mix ecto.create
$ docker-compose run web mix ecto.migrate
$ docker-compose up
```
