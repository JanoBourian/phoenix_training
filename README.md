# phoenix_training
This repository will be used to train phoenix framework to delivery excellent software

## Creating the project

Database configuration

* Docker steps
```bash
docker run -d --name vemosla_db -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_USER=myusername -e PGDATA=/var/lib/postgresql/data/pgdata -p 5435:5432 -v C:\\Users\\super\\Documents\\databases\\vemosla_db:/var/lib/postgresql/data -d postgres
```

For *graphic* 

```bash
docker run -d --name graphic -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres -e PGDATA=/var/lib/postgresql/data/pgdata -p 5432:5432 -v C:\\Users\\super\\Documents\\databases\\graphic:/var/lib/postgresql/data -d postgres
```

To configure the *.env* file I need to change the *runtime.exs* file and add the dependency *dotenvy* in *mix.exs* file

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

### About controllers, views and templates

Well, the next step is create the view and the template in our controller page *page_controller*

```elixir
defmodule VemoslaWeb.PageController do
  use VemoslaWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def index(conn, _params) do
    render(conn, :index, layout: false)
  end
end
```

and ensure that the template file gets access to the html folder in *page_html*

```elixir
defmodule VemoslaWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use VemoslaWeb, :html

  embed_templates "page_html/*"
end
```

and to add the corresponding html code in *page_html/index.html.heex*

```html
<h1> Hello @janobourian </h1>

<section>
  <h2>Hello World, from Phoenix!</h2>
</section>
```

### Adding a Plug

Function plug

In *endpoint.ex* a function plug is writen as: 

```elixir
defmodule HelloWeb.Endpoint do
  ...

  plug :introspect
  plug HelloWeb.Router

  def introspect(conn, _opts) do
    IO.puts """
    Verb: #{inspect(conn.method)}
    Host: #{inspect(conn.host)}
    Headers: #{inspect(conn.req_headers)}
    """

    conn
  end
end
```

Module plug

First we need to create a file in *lib/vemosla_web/plugs/locale.ex* where we will create our plug as module

```elixir
defmodule VemoslaWeb.Plugs.Locale do
  import Plug.Conn

  @locales ["en", "fr", "de"]

  def init(default), do: default

  def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
    assign(conn, :locale, loc)
  end

  def call(conn, default) do
    assign(conn, :locale, default)
  end

end
```

After that we need to add our plug in *router.ex* 

```elixir
defmodule VemoslaWeb.Router do
  use VemoslaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VemoslaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug VemoslaWeb.Plugs.Locale, "en"
  end
```

Finally, we add the plug in a template, in this case in *index.html.heex*

```heex
<h1> Hello @janobourian </h1>
<p>Locale: <%= @locale %></p>
<section>
  <h2>Hello World, from Phoenix!</h2>
</section>
```

And test the Plug using *http://localhost:4000/about?locale=fr*

### Routing

To get all routes in a normal project 

```bash
mix phx.routes
```

when you have a umbrella project

```bash
mix phx.routes VemoslaWeb.Router
```

#### Resources

To create a new RESTful resource in *router.ex* you will add

```elixir
  resources "/user", UserController
```

To create a specific resource in *router.ex* you will add

```elixir
  resources "/posts", PostController, only: [:index, :show]
```

To create a new resource but without some route

```elixir
resources "/comments", CommentController, except: [:delete]
```

#### Nested resources

To nest resources in *router.ex* we add:

```elixir
resources "/users", UserController do
  resources "/posts", PostController
end
```

#### Scoped routes

```elixir
scope "/admin", VemoslaWeb.Admin do
  pipe_through :browser

  resources "/reviews", ReviewController
end
```

For /api route

```elixir
  scope "/api", VemoslaWeb.Api, as: :api do
    pipe_through :browser
    scope "/v1", V1, as: :v1 do
      resources "/images", ImageController
      resources "/reviews", ReviewController
      resources "/users", UserController
    end
  end
```

#### Pipelines

```elixir
  pipeline :auth do
    plug VemoslaWeb.Authentication
  end

  scope "/reviews", VemoslaWeb do
    pipe_through [:browser, :auth]

    resources "/", ReviewController
  end
```

#### Forward

```elixir
defmodule HelloWeb.Router do
  use HelloWeb, :router

  ...

  scope "/" do
    pipe_through [:authenticate_user, :ensure_admin]
    forward "/jobs", BackgroundJob.Plug
  end
end
```

### Controllers

#### Rendering

Using *text/2* function witout any html format (as plain text)

```elixir
defmodule VemoslaWeb.UserController do
  use VemoslaWeb, :controller

  def index(conn, params) do
    IO.puts("""
    Params inside /users: #{inspect(params)}
    """)
    text(conn, "This a text using Elixir")
  end

end
```

Now using *json/2* 

```elixir
  def janobourian(conn, %{"id" => id} = params) do
    json(conn, %{id: id})
  end
```

We can pass arguments using *Plug.Conn.asign/3*

```elixir
  def janobourian(conn, %{"id" => id} = params) do
    # json(conn, %{id: id})
    conn
    |> assign(:id, id)
    |> assign(:name, "janobourian")
    |> render(:janobourian)
  end
```

#### Rendering with other format

In this case we want to send HTML and JSON, first of all we should create *rabbit_json.ex* file with the next content

```elixir
defmodule VemoslaWeb.RabbitJSON do

  def home(_assigns) do
    %{mesagge: "This is some JSON"}
  end

end
```

after that we need to change the plug *:accepts* in *router.ex* to accept JSON format

```elixir
defmodule VemoslaWeb.Router do
  use VemoslaWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
end
```

and now we can check the JSON output in the next url *http://localhost:4000/rabbit?_format=json*

For *sending response directly*, *setting the conten type*, *setting the HTTP status*, *redirect*, *flash messages* and *error pages* check the documentation https://hexdocs.pm/phoenix/controllers.html

### Components and HEEX

To check this section please read the documentation in *https://hexdocs.pm/phoenix/components.html*

### Ecto

When we are creatting a new project phoenix will include Ecto with postgress (by default), if you want to change the database or you don't want to use a database you can pass the next arguments:

```bash
--database
--no-ecto
```

#### Create a schema

```bash
mix phx.gen.schema User users name:string email:string bio:string number_of_pets:integer
mix ecto.migrate
```

#### Trying our Schema

```bash
iex -S mix
```

```elixir
alias Vemosla.User
changeset = User.changeset(%User{}, %{})
changeset.valid?
changeset.errors
params = %{name: "Joe example", email: "joe@mail.com", bio: "An example", number_of_pets: 5, random_key: "random value"}
changeset = User.changeset(%User{}, params)
changeset.valid?
changeset.errors
changeset.changes
# here we add validate_length(:bio, min: 2)
recompile()
changeset = User.changeset(%User{}, %{bio: "A"})
changeset.errors[:bio]
# here we will have an error
# we will add validator for max bio and email
recompile()
changeset = User.changeset(%User{}, %{email: "example.com"})
changeset.errors[:email]
# we will get an error
```

#### Data persistence

```bash
iex -S mix
```

```elixir
alias Vemosla.{Repo, User}
Repo.insert(%User{email: "user1@example.com"})
Repo.insert(%User{email: "user2@example.com"})
Repo.all(User)
```

Using Ecto query advanced tools

```elixir
import Ecto.Query
Repo.all(from u in User, select: u.email)
Repo.one(from u in User, where: ilike(u.email, "%1%"), select: count(u.id))
Repo.all(from u in User, select: %{u.id => u.email})
```

#### Using other database

For get that information please check the documentation in *https://hexdocs.pm/phoenix/ecto.html*

#### Ecto Repo Functions

```elixir
alias Bookstore.Catalog
alias Bookstore.Catalog.{Author, Category}
alias Bookstore.Repo

author = %Author{name: "dardo"}
{status, resp } = Repo.insert(author)
Catalog.list_authors()
author = Catalog.get_author!(result.id)
{status, resp } = Repo.delete(author)

# Another kind of operations
# :count, :sum, :min, :max, :avg
Repo.aggregate(Author, :count, :id)

## Query

import Ecto.Query

query = from a in "authors", select: {a.id, a.name}

Repo.all(query)

query = from a in "authors", select: [:id, :name]

Repo.all(query)

# using where and safe mode
author_name = "J. K. Rowling"
query = from a in "authors", where: [name: ^author_name], select: {a.id, a.name}
Repo.all(query)

author_id = "3cc0f05e-43f3-4d5b-9138-941360c260fe"
query = from a in "authors", where: [id: type(^author_id, Ecto.UUID)], select: {a.id, a.name}
Repo.all(query)

query = from c in "categories", where: like(c.name, "%fiction%"), select: {c.name}, order_by: c.name
Repo.all(query)

query = from c in "categories", where: like(c.name, "%fiction%"), select: {c.name}, order_by: [desc: c.name]
Repo.all(query)

# using schemas and queries
alias Bookstore.Catalog.{Author, Category}
alias Bookstore.Repo
import Ecto.Query 

author = %Author{"name": "Mark Twain"}
Repo.insert(author)

query = from a in Author, where: like(a.name, "%T%"), select: {a.name}
Repo.all(query)
```

#### Ecto for graphic application 

```elixir
alias Graphic.Vacation.{Place, Booking, Review}
alias Graphic.Accounts.User

alias Graphic.Repo
alias Graphic.Vacation
alias Graphic.Accounts

import Ecto.Query

query = from p in Place
query |> Repo.all()

query = from p in query, limit: 15
query |> Repo.all()

query = from p in Place, limit: 15
query |> Repo.all()

query = from p in Place, where: p.max_guests >= 3, limit: 15
query |> Repo.all()

query = from p in query, where: p.wifi == true
query |> Repo.all()

query = from p in query, where: ilike(p.name, "%lake%")
query |> Repo.all()

# with the criteria function
criteria = [{:limit, 2}, {:filter, [{:matching, "lake"}, {:wifi, true}, {:guest_count, 3}]}]
Vacation.list_places(criteria)

# using Accounts context

Accounts.authenticate("user", "password")
```

### Contexts

The next commands help you to create generatos to isolate your application:

```bash
mix phx.gen.html
mix phx.gen.json
mix phx.gen.live
mix phx.gen.context
```

To create a context module:

```bash
mix phx.gen.html Catalog Product products title:string description:string price:decimal views:integer
mix deps.get
mix ecto.migrate
```

Note: if you have some trouble with *mix ecto.migrate* command, you should add *Dotenvy* dep in all *mix.ex* files and run *mix deps.get* and *mix ecto.migrate* in the next route *\phoenix_training\vemosla_umbrella*

#### Adding catalog functions

In *catalog.ex*

```elixir
def inc_page_views(%Product{} = product) do
    {1, [%Product{views: views}]} =
      from(p in Product, where: p.id == ^product.id, select: [:views])
      |> Repo.update_all(inc: [views: 1])
    put_in(product.views, views)
end
```

Now, in *product_controller.ex*

```elixir
  def show(conn, %{"id" => id}) do
    product =
      id
      |> Catalog.get_product!()
      |> Catalog.inc_page_views()

    render(conn, :show, product: product)
  end
```

#### In-context relationships

```bash
mix phx.gen.context Catalog Category categories title:string:unique
mix deps.get
mix ecto.gen.migration create_product_categories
```

In the last migration you should add

```elixir
defmodule Hello.Repo.Migrations.CreateProductCategories do
  use Ecto.Migration

  def change do
    create table(:product_categories, primary_key: false) do
      add :product_id, references(:products, on_delete: :delete_all, column: :id, type: :binary_id)
      add :category_id, references(:categories, on_delete: :delete_all, column: :id, type: :binary_id)
    end

    create index(:product_categories, [:product_id])
    create unique_index(:product_categories, [:category_id, :product_id])
  end
end
```

Now we have a table with the relationship between products and categories, but, now we need to create some categories in *priv/repo/seeds.ex*

```elixir
for title <- ["Home Improvement", "Power Tools", "Gardening", "Books", "Education"] do
  {:ok, _} = Hello.Catalog.create_category(%{title: title})
end
```

and run 

```bash
mix run priv/repo/seeds.exs
```

and you can try with:

```bash
mix ecto.setup
mix ecto.reset
```

Now is time to asociate products with categories in our web layer, in *lib/vemosla/catalog/product.ex*

```elixir
  schema "products" do
    field :description, :string
    field :title, :string
    field :price, :decimal
    field :views, :integer

    many_to_many :categories, Category, join_through: "product_categories", on_replace: :delete

    timestamps()
  end
```

#### Cross-context dependecies

In *vemosla_web* root we will create the context and the schema for our ShoppingCart and Cart

```bash
mix phx.gen.context ShoppingCart Cart carts user_uuid:uuid:unique
```

Now we will create the *CartItem* 

```bash
mix phx.gen.context ShoppingCart CartItem cart_items cart_id:references:carts product_id:references:products price_when_carted:decimal quantity:integer
```

#### Cross-context data

Associate a cart to its items: 

```elixir
  schema "carts" do
    field :user_uuid, Ecto.UUID

+   has_many :items, Hello.ShoppingCart.CartItem

    timestamps()
  end
```

Change the *cart_item.ex*:

```elixir
  schema "cart_items" do
    field :price_when_carted, :decimal
    field :quantity, :integer
-   field :cart_id, :id
-   field :product_id, :id

+   belongs_to :cart, Hello.ShoppingCart.Cart
+   belongs_to :product, Hello.Catalog.Product

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:price_when_carted, :quantity])
    |> validate_required([:price_when_carted, :quantity])
+   |> validate_number(:quantity, greater_than_or_equal_to: 0, less_than: 100)
  end
```

#### Adding Shopping Cart functions

In *router.ex* we should add: 

```elixir
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HelloWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
+   plug :fetch_current_user
+   plug :fetch_current_cart
  end

+ defp fetch_current_user(conn, _) do
+   if user_uuid = get_session(conn, :current_uuid) do
+     assign(conn, :current_uuid, user_uuid)
+   else
+     new_uuid = Ecto.UUID.generate()
+
+     conn
+     |> assign(:current_uuid, new_uuid)
+     |> put_session(:current_uuid, new_uuid)
+   end
+ end

+ alias Hello.ShoppingCart
+
+ defp fetch_current_cart(conn, _opts) do
+   if cart = ShoppingCart.get_cart_by_user_uuid(conn.assigns.current_uuid) do
+     assign(conn, :cart, cart)
+   else
+     {:ok, new_cart} = ShoppingCart.create_cart(conn.assigns.current_uuid)
+     assign(conn, :cart, new_cart)
+   end
+ end
```

also we need to add the routes:

```elixir
  scope "/", HelloWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/products", ProductController

+   resources "/cart_items", CartItemController, only: [:create, :delete]

+   get "/cart", CartController, :show
+   put "/cart", CartController, :update
  end
```

Create cart item controller in */controllers/cart_item_controller.ex*:

```elixir
defmodule HelloWeb.CartItemController do
  use HelloWeb, :controller

  alias Hello.ShoppingCart

  def create(conn, %{"product_id" => product_id}) do
    case ShoppingCart.add_item_to_cart(conn.assigns.cart, product_id) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item added to your cart")
        |> redirect(to: ~p"/cart")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was an error adding the item to your cart")
        |> redirect(to: ~p"/cart")
    end
  end

  def delete(conn, %{"id" => product_id}) do
    {:ok, _cart} = ShoppingCart.remove_item_from_cart(conn.assigns.cart, product_id)
    redirect(conn, to: ~p"/cart")
  end
end
```

Now we will change the *shopping_cart.ex* interface:

```elixir
+  alias Hello.Catalog
-  alias Hello.ShoppingCart.Cart
+  alias Hello.ShoppingCart.{Cart, CartItem}

+  def get_cart_by_user_uuid(user_uuid) do
+    Repo.one(
+      from(c in Cart,
+        where: c.user_uuid == ^user_uuid,
+        left_join: i in assoc(c, :items),
+        left_join: p in assoc(i, :product),
+        order_by: [asc: i.inserted_at],
+        preload: [items: {i, product: p}]
+      )
+    )
+  end

- def create_cart(attrs \\ %{}) do
-   %Cart{}
-   |> Cart.changeset(attrs)
+ def create_cart(user_uuid) do
+   %Cart{user_uuid: user_uuid}
+   |> Cart.changeset(%{})
    |> Repo.insert()
+   |> case do
+     {:ok, cart} -> {:ok, reload_cart(cart)}
+     {:error, changeset} -> {:error, changeset}
+   end
  end

+  defp reload_cart(%Cart{} = cart), do: get_cart_by_user_uuid(cart.user_uuid)
+
+  def add_item_to_cart(%Cart{} = cart, product_id) do
+    product = Catalog.get_product!(product_id)
+
+    %CartItem{quantity: 1, price_when_carted: product.price}
+    |> CartItem.changeset(%{})
+    |> Ecto.Changeset.put_assoc(:cart, cart)
+    |> Ecto.Changeset.put_assoc(:product, product)
+    |> Repo.insert(
+      on_conflict: [inc: [quantity: 1]],
+      conflict_target: [:cart_id, :product_id]
+    )
+  end
+
+  def remove_item_from_cart(%Cart{} = cart, product_id) do
+    {1, _} =
+      Repo.delete_all(
+        from(i in CartItem,
+          where: i.cart_id == ^cart.id,
+          where: i.product_id == ^product_id
+        )
+      )
+
+    {:ok, reload_cart(cart)}
+  end
```

Now we will create the *cart_controller.ex*

```elixir
defmodule HelloWeb.CartController do
  use HelloWeb, :controller

  alias Hello.ShoppingCart

  def show(conn, _params) do
    render(conn, :show, changeset: ShoppingCart.change_cart(conn.assigns.cart))
  end
end
```

The *cart_html.ex* file:

```elixir
defmodule VemoslaWeb.CartHTML do
  use VemoslaWeb, :html

  alias Vemosla.ShoppingCart

  embed_templates "cart_html/*"

  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
end

```

The */cart_html/show.html.heex* file:

```html
<%= if @cart.items == [] do %>
  <.header>
    My Cart
    <:subtitle>Your cart is empty</:subtitle>
  </.header>
<% else %>
  <.header>
    My Cart
  </.header>

  <.simple_form :let={f} for={@changeset} action={~p"/cart"}>
    <.inputs_for :let={item_form} field={f[:items]}>
	<% item = item_form.data %>
      <.input field={item_form[:quantity]} type="number" label={item.product.title} />
      <%= currency_to_str(ShoppingCart.total_item_price(item)) %>
    </.inputs_for>
    <:actions>
      <.button>Update cart</.button>
    </:actions>
  </.simple_form>

  <b>Total</b>: <%= currency_to_str(ShoppingCart.total_cart_price(@cart)) %>
<% end %>

<.back navigate={~p"/products"}>Back to products</.back>
```

We will add this code in *shopping_cart.ex* interface: 

```elixir
  def total_item_price(%CartItem{} = item) do
    Decimal.mult(item.product.price, item.quantity)
  end

  def total_cart_price(%Cart{} = cart) do
    Enum.reduce(cart.items, 0, fn item, acc ->
      item
      |> total_item_price()
      |> Decimal.add(acc)
    end)
  end
```

Now return to *cart_controller.ex* and add the follow code:

```elixir
  def update(conn, %{"cart" => cart_params}) do
    case ShoppingCart.update_cart(conn.assigns.cart, cart_params) do
      {:ok, _cart} ->
        redirect(conn, to: ~p"/cart")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was an error updating your cart")
        |> redirect(to: ~p"/cart")
    end
  end
```

And back to the interface *shopping_cart.ex*:

```elixir
  def update_cart(%Cart{} = cart, attrs) do
    changeset =
      cart
      |> Cart.changeset(attrs)
      |> Ecto.Changeset.cast_assoc(:items, with: &CartItem.changeset/2)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:cart, changeset)
    |> Ecto.Multi.delete_all(:discarded_items, fn %{cart: cart} ->
      from(i in CartItem, where: i.cart_id == ^cart.id and i.quantity == 0)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{cart: cart}} -> {:ok, cart}
      {:error, :cart, changeset, _changes_so_far} -> {:error, changeset}
    end
  end
```

#### Adding an Orders context

You can check the info in the documentation: https://hexdocs.pm/phoenix/contexts.html

## JSON and APIs

```bash
mix phx.gen.json Urls Url urls link:string title:string
```

And in *router.ex* using */api* context:

```elixir
  scope "/api", VemoslaWeb do
    pipe_through :api
    resources "/urls", UrlController, except: [:new, :edit]
  end
```

```bash
mix ecto.migrate
```

To create a specific migration:

```bash
mix ecto.gen.migration add_weather_table
```