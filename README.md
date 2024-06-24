# phoenix_training
This repository will be used to train phoenix framework to delivery excellent software

## Creating the project

Database configuration
```bash
docker run -d --name vemosla_db -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_USER=myusername -e PGDATA=/var/lib/postgresql/data/pgdata -p 5435:5432 -v C:\\Users\\super\\Documents\\databases\\vemosla_db:/var/lib/postgresql/data -d postgres
```

```bash
mix archive.install hex phx_new
mix phx.new --umbrella --live --binary-id vemosla
cd vemosla_umbrella
mix ecto.create
mix phx.server
iex -S mix phx.server
```

Dependencies and environment variables configuration

https://hexdocs.pm/dotenvy/readme.html

```bash
mix deps.get
```