# phoenix_training
This repository will be used to train phoenix framework to delivery excellent software

## Creating the project

```bash
mix archive.install hex phx_new
mix phx.new --umbrella --live --binary-id vemosla
cd vemosla_umbrella
mix ecto.create
mix phx.server
iex -S mix phx.server
```