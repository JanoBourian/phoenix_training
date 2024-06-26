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

## Web application description

* assests: Static files are here
* lib: Controllers, chanels, liveview, templates, views, endpoints/router and telemetry
* priv: Another kind of files
* test: Test for web application

### Work with static files

The purpose of this block of code is to save the profile pics inside the static file.

First of all I will configure the *dev.exs* file adding the route:

```elixir
config :vemosla,
  uploads_files_path: "files",
  uploads_url_path: "/files"
```

and after that I will add the Plug to work with static files in *endpoint.ex*

```elixir
plug Plug.Static,
    at: Application.get_env(:vemosla, :uploads_url_path),
    from: Application.get_env(:vemosla, :uploads_files_path),
    gzip: false
```

The "Plugs" and their functions:

* Plug.Static: Static files access
* Plug.RequestId: Allow the x-request-id header as :request_id
* Plug.Telemetry: It emit two events, one at the start of the request and other just before to send the request to the web client
* Plug.Parsers: Decode the body's content
* Plug.MethodOverride: Override the start method
* Plug.Head: Change the method HEAD for GET method
* Plug.Session: Cookies and sessions
* Plug.VemoslaWeb.Router: The router is another Plug


### Add a new route in Frontend

In *router.ex* I can add new frontend routes using the correct scope:

```elixir
  scope "/", VemoslaWeb do
    pipe_through :browser

    get "/", PageController, :home

    get "/about", PageController, :home
  end
```